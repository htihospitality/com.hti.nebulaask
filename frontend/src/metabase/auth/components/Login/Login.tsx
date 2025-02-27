import React, { useCallback } from "react";
import { t } from "ttag";
import AuthLayout from "../../containers/AuthLayout";
import { AuthProvider } from "../../types";
import {
  ActionList,
  ActionListItem,
  LoginPanel,
  LoginTitle,
} from "./Login.styled";
import { AuthUI } from "@hti-auth/react-web";
import Http from "../../../core/http/http";

export interface LoginProps {
  providers: AuthProvider[];
  providerName?: string;
  redirectUrl?: string;
}

const Login = ({
  providers,
  providerName,
  redirectUrl,
}: LoginProps): JSX.Element => {
  const selection = getSelectedProvider(providers, providerName);

  const onSignInSuccess = useCallback(({ idToken, handle }) => {
    Http.request({
      method: Http.Method.POST,
      url: "api/session/hti_auth",
      data: { token: idToken },
    })
      .then(r => handle({ response: r, sessionToken: r.data.sessionToken }))
      .then(() => window.location.replace("/"))
      .catch(e => console.log(e) /*handleError(e, 'Sign-in failed.') */);
  }, []);

  return (
    <>
      <AuthUI
        appLogo={"app/img/AskNebula-logo.png"}
        onSignInSuccess={onSignInSuccess}
        logout={false}
      />
      {/*<AuthLayout>*/}
      {/*  <LoginTitle>{t`Sign in to Metabase`}</LoginTitle>*/}
      {/*  {selection && selection.Panel && (*/}
      {/*    <LoginPanel>*/}
      {/*      <selection.Panel redirectUrl={redirectUrl} />*/}
      {/*    </LoginPanel>*/}
      {/*  )}*/}
      {/*  {!selection && (*/}
      {/*    <ActionList>*/}
      {/*      {providers.map(provider => (*/}
      {/*        <ActionListItem key={provider.name}>*/}
      {/*          <provider.Button isCard={true} redirectUrl={redirectUrl} />*/}
      {/*        </ActionListItem>*/}
      {/*      ))}*/}
      {/*    </ActionList>*/}
      {/*  )}*/}
      {/*</AuthLayout>*/}
    </>
  );
};

const getSelectedProvider = (
  providers: AuthProvider[],
  providerName?: string,
): AuthProvider | undefined => {
  const provider =
    providers.length > 1
      ? providers.find(p => p.name === providerName)
      : providers[0];

  return provider?.Panel ? provider : undefined;
};

export default Login;
