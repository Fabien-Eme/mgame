import { region } from "firebase-functions";
import { GoogleAuth } from 'google-auth-library';
import { SecretManagerServiceClient } from '@google-cloud/secret-manager';
import admin from "firebase-admin";
import jwt from 'jsonwebtoken';

const client = new SecretManagerServiceClient();

const baseUrl = 'https://walletobjects.googleapis.com/walletobjects/v1';

const issuerId = '3388000000022314766';


admin.initializeApp();
export const createAchievementPass = region("us-west1").runWith({
    serviceAccount: 'googlewallet@mgame-8c88b.iam.gserviceaccount.com'
}).https.onRequest(async (req, res) => {

    const secretName = "projects/439365888460/secrets/service_account_key/versions/1";
    const [version] = await client.accessSecretVersion({ name: secretName });
    const serviceAccountKey = JSON.parse(version.payload.data);

    let credentials = serviceAccountKey;

    const { objectSuffix, userName } = req.body;

    /// Classes
    /// achievement
    /// joinMyTeam



    const db = admin.firestore();

    /// Get air quality
    const airDocRef = db.collection("air_quality").doc("current");
    const airDoc = await airDocRef.get();
    const currentAirQuality = airDoc.data().globalText;
    const currentAirQualityColor = airDoc.data().globalColor;

    /// Get number of citizen
    const citizenDocRef = db.collection("achievements").doc(`${objectSuffix}`);
    const citizenDoc = await citizenDocRef.get();
    const citizen = citizenDoc.data().citizen;

    /// Define content
    let header;
    let heroImage;

    if (objectSuffix == "cityCleaner") {
        header = "City Cleaner";
        heroImage = `https://storage.googleapis.com/images_wallet/city.${currentAirQualityColor}.jpg`;
    }
    if (objectSuffix == "garbageCollector") {
        header = "Garbage Collector";
        heroImage = `https://storage.googleapis.com/images_wallet/garbage.${currentAirQualityColor}.jpg`;
    }

    let newObject = {
        'id': `${issuerId}.${objectSuffix}.${userName}`,
        'classId': `${issuerId}.achievement`,
        'state': 'ACTIVE',
        "groupingInfo": {
            "groupingId": "achievementCards",
        },
        "logo": {
            "sourceUri": {
                "uri": "https://storage.googleapis.com/images_wallet/logo_small.jpg",
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
                "value": "MGame Collectible",
            },
        },
        "subheader": {
            "defaultValue": {
                "language": "en-US",
                "value": "Achievement",
            },
        },
        "header": {
            "defaultValue": {
                "language": "en-US",
                "value": `${header}`,
            },
        },
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
