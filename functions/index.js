import { region } from "firebase-functions";
import { GoogleAuth } from 'google-auth-library';
import { SecretManagerServiceClient } from '@google-cloud/secret-manager';
import jwt from 'jsonwebtoken';

const client = new SecretManagerServiceClient();

const baseUrl = 'https://walletobjects.googleapis.com/walletobjects/v1';

const issuerId = '3388000000022314766';

export const createGoogleWalletCard = region("europe-west1").runWith({
    serviceAccount: 'googlewallet@mgame-8c88b.iam.gserviceaccount.com'
}).https.onRequest(async (req, res) => {

    const secretName = "projects/439365888460/secrets/service_account_key/versions/1";
    const [version] = await client.accessSecretVersion({ name: secretName });
    const serviceAccountKey = JSON.parse(version.payload.data);

    let credentials = serviceAccountKey;

    const { classId, objectSuffix } = req.body;

    /// Classes
    /// achievement
    /// joinMyTeam


    let newObject = {
        'id': `${issuerId}.${objectSuffix}`,
        'classId': `${issuerId}.${classId}`,
        'state': 'ACTIVE',
        "groupingInfo": {
            "groupingId": "achievementCards",
        },
        "logo": {
            "sourceUri": {
                "uri": "https://storage.googleapis.com/wallet-lab-tools-codelab-artifacts-public/pass_google_logo.jpg",
            },
            "contentDescription": {
                "defaultValue": {
                    "language": "en-US",
                    "value": "LOGO_IMAGE_DESCRIPTION",
                },
            },
        },
        "cardTitle": {
            "defaultValue": {
                "language": "en-US",
                "value": "Achievement MGame",
            },
        },
        "subheader": {
            "defaultValue": {
                "language": "en-US",
                "value": "Chief",
            },
        },
        "header": {
            "defaultValue": {
                "language": "en-US",
                "value": "Alex McJacobs",
            },
        },
        "textModulesData": [
            {
                "id": "points",
                "header": "POINTS",
                "body": "1112",
            },
            {
                "id": "contacts",
                "header": "CONTACTS",
                "body": "79",
            },
        ],
        "barcode": {
            "type": "QR_CODE",
            "value": "BARCODE_VALUE",
            "alternateText": "",
        },
        "hexBackgroundColor": "#80e156",
        "heroImage": {
            "sourceUri": {
                "uri": "https://storage.googleapis.com/wallet-lab-tools-codelab-artifacts-public/google-io-hero-demo-only.png",
            },
            "contentDescription": {
                "defaultValue": {
                    "language": "en-US",
                    "value": "HERO_IMAGE_DESCRIPTION",
                },
            },
        },
    };


    // Create the JWT claims
    let claims = {
        iss: credentials.client_email,
        aud: 'google',
        origins: [],
        typ: 'savetowallet',
        payload: {
            genericObjects: [newObject]
        },
    };

    // The service account credentials are used to sign the JWT
    let token = jwt.sign(claims, credentials.private_key, { algorithm: 'RS256' });

    res.send(`https://pay.google.com/gp/v/save/${token}`);
});


///
///
/// LIST ALL CLASS
export const listAllClass = region("europe-west1").runWith({
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
export const listAllObject = region("europe-west1").runWith({
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


///
///
/// UPDATE A CLASS
export const updateClass = region("europe-west1").runWith({
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

    let modifiedClass = {
        'id': `${issuerId}.${classId}`,
        "classTemplateInfo": {
            "cardTemplateOverride": {
                "cardRowTemplateInfos": [
                    {
                        "twoItems": {
                            "startItem": {
                                "firstValue": {
                                    "fields": [
                                        {
                                            "fieldPath": "object.textModulesData['points']",
                                        },
                                    ],
                                },
                            },
                            "endItem": {
                                "firstValue": {
                                    "fields": [
                                        {
                                            "fieldPath": "object.textModulesData['contacts']",
                                        },
                                    ],
                                },
                            },
                        },
                    },
                ],
            },
        },
    };

    let response = await httpClient.request({
        url: `${baseUrl}/genericClass/${modifiedClass.id}`,
        method: 'PUT',
        data: modifiedClass
    });

    res.send(`${response.status}`);
});


///
///
/// GET AIR POLLUTION
export const getAirPollution = region("europe-west1").runWith({
    serviceAccount: 'googlewallet@mgame-8c88b.iam.gserviceaccount.com'
}).https.onRequest(async (req, res) => {

    const secretName = "projects/439365888460/secrets/service_account_key/versions/1";
    const [version] = await client.accessSecretVersion({ name: secretName });
    const serviceAccountKey = JSON.parse(version.payload.data);

    let credentials = serviceAccountKey;

    let httpClient = new GoogleAuth({
        credentials: credentials,
        scopes: 'https://www.googleapis.com/auth/cloud-platform'
    });

    let requestedData = {
        "location": {
            "latitude": 37.419734,
            "longitude": -122.0827784
        }
    };

    let response = await httpClient.request({
        url: `https://airquality.googleapis.com/v1/currentConditions:lookup`,
        method: 'POST',
        data: requestedData,
    });


    res.send(`${JSON.stringify(response.data)}`);
});


// {"dateTime":"2024-02-29T18:00:00Z","regionCode":"us","indexes":[{"code":"uaqi","displayName":"Universal AQI","aqi":71,"aqiDisplay":"71","color":{"red":0.49803922,"green":0.8039216,"blue":0.2},"category":"Good air quality","dominantPollutant":"pm10"}]}