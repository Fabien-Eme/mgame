import { region } from "firebase-functions";
import { GoogleAuth } from 'google-auth-library';

import { SecretManagerServiceClient } from '@google-cloud/secret-manager';
const client = new SecretManagerServiceClient();
const baseUrl = 'https://walletobjects.googleapis.com/walletobjects/v1';
const issuerId = '3388000000022314766';

import admin from "firebase-admin";
admin.initializeApp();
const firestore = admin.firestore;

///
///
/// UPDATE A CLASS
export const updateClass = region("us-west1").runWith({
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
                                            "fieldPath": "object.textModulesData['citizen']",
                                        },
                                    ],
                                },
                            },
                            "endItem": {
                                "firstValue": {
                                    "fields": [
                                        {
                                            "fieldPath": "object.textModulesData['air_quality']",
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
/// AUTOMATICALLY PATCH OBJECTS
export const automaticallyPatchObjects = region("us-west1").runWith({
    serviceAccount: 'googlewallet@mgame-8c88b.iam.gserviceaccount.com'
}).firestore.document('air_quality/current').onUpdate(async (change, context) => {

    const targetAudience = 'https://us-west1-mgame-8c88b.cloudfunctions.net/manuallyPatchObjects';
    const url = targetAudience;
    const auth = new GoogleAuth();

    const clientGoogleFunction = await auth.getIdTokenClient(targetAudience);
    const response = await clientGoogleFunction.request({ url });

    return 'Update done';

});


///
///
/// MANUALLY PATCH OBJECTS
export const manuallyPatchObjects = region("us-west1").runWith({
    serviceAccount: 'googlewallet@mgame-8c88b.iam.gserviceaccount.com'
}).https.onRequest(async (req, res) => {

    const db = admin.firestore();

    /// Get air quality
    const airDocRef = db.collection("air_quality").doc("current");
    const airDoc = await airDocRef.get();
    const currentAirQuality = airDoc.data().globalText;
    const currentAirQualityColor = airDoc.data().globalColor;

    /// Get number of citizen cityCleaner
    const cityCleanerCitizenDoc = await db.collection("achievements").doc("cityCleaner").get();
    const cityCleanerCitizen = cityCleanerCitizenDoc.data().citizen;

    /// Get number of citizen garbageCollector
    const garbageCollectorCitizenDoc = await db.collection("achievements").doc("garbageCollector").get();
    const garbageCollectorCitizen = garbageCollectorCitizenDoc.data().citizen;




    const targetAudience = 'https://us-west1-mgame-8c88b.cloudfunctions.net/listAllObject';
    const url = targetAudience;
    const auth = new GoogleAuth();

    const clientGoogleFunction = await auth.getIdTokenClient(targetAudience);
    const response = await clientGoogleFunction.request({ url });

    const idsArray = response.data.split(', ');


    const secretName = "projects/439365888460/secrets/service_account_key/versions/1";
    const [version] = await client.accessSecretVersion({ name: secretName });
    const serviceAccountKey = JSON.parse(version.payload.data);

    let credentials = serviceAccountKey;

    let httpClient = new GoogleAuth({
        credentials: credentials,
        scopes: 'https://www.googleapis.com/auth/wallet_object.issuer'
    });

    idsArray.forEach(async function (id) {
        const parts = id.split('.');
        const objectType = parts[1];

        let citizen;
        let heroImage;

        if (objectType == "cityCleaner") {
            citizen = cityCleanerCitizen;
            heroImage = `https://storage.googleapis.com/images_wallet/city.${currentAirQualityColor}.jpg`;
        }
        if (objectType == "garbageCollector") {
            citizen = garbageCollectorCitizen;
            heroImage = `https://storage.googleapis.com/images_wallet/garbage.${currentAirQualityColor}.jpg`;
        }

        let objectPatched = {
            "textModulesData": [
                {
                    "id": "citizen",
                    "header": "CITIZEN",
                    "body": `${citizen}`,
                },
                {
                    "id": "air_quality",
                    "header": "AIR QUALITY",
                    "body": `${currentAirQuality}`,
                },
            ],
            "hexBackgroundColor": `#${currentAirQualityColor}`,
            "heroImage": {
                "sourceUri": {
                    "uri": `${heroImage}`,
                },
                "contentDescription": {
                    "defaultValue": {
                        "language": "en-US",
                        "value": "HERO_IMAGE_DESCRIPTION",
                    },
                },
            },
        };

        let response = await httpClient.request({
            url: `${baseUrl}/genericObject/${id}`,
            method: 'PATCH',
            data: objectPatched
        });

    });

    res.send('Done');
});