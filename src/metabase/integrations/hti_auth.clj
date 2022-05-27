(ns metabase.integrations.hti-auth
  (:require [clojure.string :as str]
            [clojure.tools.logging :as log]
            [metabase.api.common :as api]
            [metabase.models.user :as user :refer [User]]
            [metabase.plugins.classloader :as classloader]
            [metabase.util :as u]
            [metabase.util.i18n :refer [deferred-tru trs tru]]
            [schema.core :as s]
            [toucan.db :as db]
            [metabase.models.permissions-group :as perms-group])
  (:import (com.hti.auth.server2 HtiAuth)))

;; Load EE implementation if available
(u/ignore-exceptions (classloader/require 'metabase-enterprise.enhancements.integrations.google))

(def ^:private non-existant-account-message
  (deferred-tru "You'll need an administrator to create a Metabase account before you can use HTI to log in."))

(defn- verify-hti-auth-token-claims
  [token-claims]
  (when-not (= (get token-claims "aud") "nebulaone")
    (throw (ex-info (str (deferred-tru "HTI Sign-In token appears to be incorrect.")
                      (deferred-tru "Double check that it comes from HTI (aud must equal `nebulaone`."))
             {:status-code 400})))
  (when-not (= (get token-claims "email_verified" ) true)
    (throw (ex-info (tru "Email is not verified.") {:status-code 400})))
  {:name (get token-claims "name")
   :email (get token-claims "email")})

(defn- autocreate-user-allowed-for-email? [email]
  (boolean
   (when-let [domains "hti-systems.co.za"]
     (some
      (partial u/email-in-domain? email)
      (str/split domains #"\s*,\s*")))))

(defn- check-autocreate-user-allowed-for-email
  "Throws if an admin needs to intervene in the account creation."
  [email]
  (when-not (autocreate-user-allowed-for-email? email)
    (throw
     (ex-info (str non-existant-account-message)
              {:status-code 401
               :errors  {:_error non-existant-account-message}}))))

(s/defn ^:private hti-auth-create-new-user!
  [{:keys [email] :as new-user} :- user/NewUser]
  (check-autocreate-user-allowed-for-email email)
  ;; this will just give the user a random password; they can go reset it if they ever change their mind and want to
  ;; log in without HTI Auth; this lets us keep the NOT NULL constraints on password / salt without having to make
  ;; things hairy and only enforce those for non-Google Auth users
   (let [created-user (user/create-new-google-auth-user! new-user)]
     (user/set-permissions-groups! created-user #{(perms-group/all-users) (perms-group/admin)})
     created-user))

(s/defn ^:private hti-auth-fetch-or-create-user! :- metabase.models.user.UserInstance
  [first-name last-name email]
  (log/info "First Name" first-name)
  (log/info "First Name" last-name)
  (or (db/select-one [User :id :email :last_login] :%lower.email (u/lower-case-en email))
      (hti-auth-create-new-user! {:first_name first-name
                                  :last_name  last-name
                                  :email      email})))

(defn do-hti-auth
  "Use HTIAuth to perform an authentication"
  [{{:keys [token]} :body, :as _request}]
  (let [token-claims                           (-> (HtiAuth/getInstance)
                                                 (.verifyIdToken token))
        {:keys [name email]}                   (verify-hti-auth-token-claims token-claims)
        first-name (subs name 0 (str/index-of name, " "))
        last-name (subs name (+ 1 (str/index-of name, " ")))]
    (log/info (trs "Successfully authenticated HTI Sign-In token for: {0}" name))
    (api/check-500 (hti-auth-fetch-or-create-user! first-name last-name email))))
