import { region } from "firebase-functions";
import { GoogleAuth } from 'google-auth-library';

import { SecretManagerServiceClient } from '@google-cloud/secret-manager';
const client = new SecretManagerServiceClient();
const baseUrl = 'https://walletobjects.googleapis.com/walletobjects/v1';
const issuerId = '3388000000022314766';


///
///
/// LIST ALL CLASS
export const listAllClass = region("us-west1").runWith({
    serviceAccount: 'googlewallet@mgame-8c88b.iam.gserviceaccount.com'
}).https.onRequest(async (req, res) => {


    let credentials = serviceAccountKey;

    let httpClient = new GoogleAuth({
        credentials: credentials,
        scopes: 'https://www.googleapis.com/auth/wallet_object.issuer'
    });



    let response = await httpClient.request({
        url: `${baseUrl}/genericClass?issuerId=${issuerId}`,
        method: 'GET'
    });

    const resources = response.data.resources;
    const ids = resources.map(resource => resource.id);
    const idsString = ids.join(', ');

    res.send(`${idsString}`);
});

///
///
/// LIST ALL OBJECT
export const listAllObject = region("us-west1").runWith({
    serviceAccount: 'googlewallet@mgame-8c88b.iam.gserviceaccount.com'
}).https.onRequest(async (req, res) => {

    const secretName = "projects/439365888460/secrets/service_account_key/versions/1";
    const [version] = await client.accessSecretVersion({ name: secretName });
    const serviceAccountKey = JSON.parse(version.payload.data);

    let credentials = serviceAccountKey;

    let httpClient = new GoogleAuth({
        credentials: credentials,
        scopes: 'https://www.googleapis.com/auth/wallet_object.issuer'
    });


    let classId = 'achievement';

    let response = await httpClient.request({
        url: `${baseUrl}/genericObject?classId=${issuerId}.${classId}`,
        method: 'GET'
    });

    const resources = response.data.resources;
    const ids = resources.map(resource => resource.id);
    const idsString = ids.join(', ');

    res.send(`${idsString}`);
});