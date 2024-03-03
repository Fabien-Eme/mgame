import { region } from "firebase-functions";
import { GoogleAuth } from 'google-auth-library';

import { SecretManagerServiceClient } from '@google-cloud/secret-manager';
const client = new SecretManagerServiceClient();

import admin from "firebase-admin";
admin.initializeApp();

///
///
/// GET AIR POLLUTION
export const getAirPollution = region("us-west1").runWith({
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

    /// Top 10 mots populated urban area, only 2 per continent (1 for Africa because of Air Api coverage, 1 for Australia, 0 for Antarctica)

    /// ASIA
    let tokyo = {
        "location": {
            "latitude": 35.689487,
            "longitude": 139.691711
        }
    };
    let responseTokyo = await httpClient.request({
        url: `https://airquality.googleapis.com/v1/currentConditions:lookup`,
        method: 'POST',
        data: tokyo,
    });

    let jakarta = {
        "location": {
            "latitude": -6.175110,
            "longitude": 106.865036
        }
    };
    let responseJakarta = await httpClient.request({
        url: `https://airquality.googleapis.com/v1/currentConditions:lookup`,
        method: 'POST',
        data: jakarta,
    });

    /// SOUTH AMERICA
    let saoPaulo = {
        "location": {
            "latitude": -23.550520,
            "longitude": -46.633308
        }
    };
    let responseSaoPaulo = await httpClient.request({
        url: `https://airquality.googleapis.com/v1/currentConditions:lookup`,
        method: 'POST',
        data: saoPaulo,
    });

    let buenosAires = {
        "location": {
            "latitude": -34.603683,
            "longitude": -58.381557
        }
    };
    let responseBuenosAires = await httpClient.request({
        url: `https://airquality.googleapis.com/v1/currentConditions:lookup`,
        method: 'POST',
        data: buenosAires,
    });

    /// NORTH AMERICA
    let mexico = {
        "location": {
            "latitude": 19.4326296,
            "longitude": -99.1331785
        }
    };
    let responseMexico = await httpClient.request({
        url: `https://airquality.googleapis.com/v1/currentConditions:lookup`,
        method: 'POST',
        data: mexico,
    });

    let newyorkCity = {
        "location": {
            "latitude": 40.7127281,
            "longitude": -74.0060152
        }
    };
    let responseNewyorkCity = await httpClient.request({
        url: `https://airquality.googleapis.com/v1/currentConditions:lookup`,
        method: 'POST',
        data: newyorkCity,
    });

    /// AFRICA
    let cairo = {
        "location": {
            "latitude": 30.0443879,
            "longitude": 31.2357257
        }
    };
    let responseCairo = await httpClient.request({
        url: `https://airquality.googleapis.com/v1/currentConditions:lookup`,
        method: 'POST',
        data: cairo,
    });


    /// EUROPE
    let london = {
        "location": {
            "latitude": 51.5074456,
            "longitude": -0.1277653
        }
    };
    let responseLondon = await httpClient.request({
        url: `https://airquality.googleapis.com/v1/currentConditions:lookup`,
        method: 'POST',
        data: london,
    });

    let paris = {
        "location": {
            "latitude": 48.8588897,
            "longitude": 2.320041
        }
    };
    let responseParis = await httpClient.request({
        url: `https://airquality.googleapis.com/v1/currentConditions:lookup`,
        method: 'POST',
        data: paris,
    });

    /// AUSTRALIA
    let sydney = {
        "location": {
            "latitude": -33.8698439,
            "longitude": 151.2082848
        }
    };
    let responseSydney = await httpClient.request({
        url: `https://airquality.googleapis.com/v1/currentConditions:lookup`,
        method: 'POST',
        data: sydney,
    });

    let total = responseTokyo.data.indexes[0].aqi + responseJakarta.data.indexes[0].aqi + responseSaoPaulo.data.indexes[0].aqi + responseBuenosAires.data.indexes[0].aqi + responseMexico.data.indexes[0].aqi + responseNewyorkCity.data.indexes[0].aqi + responseCairo.data.indexes[0].aqi + responseLondon.data.indexes[0].aqi + responseParis.data.indexes[0].aqi + responseSydney.data.indexes[0].aqi;

    let globalUAQI = total / 10;

    /// Get text and color
    let globalText;
    let globalColor;

    if (globalUAQI >= 80) {
        globalText = 'Excellent';
        globalColor = '009E3A';
    } else if (globalUAQI >= 60) {
        globalText = 'Good';
        globalColor = '84CF33';
    } else if (globalUAQI >= 40) {
        globalText = 'Moderate';
        globalColor = 'FFFF00';
    } else if (globalUAQI >= 20) {
        globalText = 'Low';
        globalColor = 'FF8C00';
    } else if (globalUAQI >= 1) {
        globalText = 'Poor';
        globalColor = 'FF0000';
    } else {
        globalText = 'Very poor';
        globalColor = '800000';
    }


    const doc = {
        'globalNumber': `${globalUAQI}`,
        'globalText': `${globalText}`,
        'globalColor': `${globalColor}`,
        'lastFetch': admin.firestore.Timestamp.now().toDate(),
    };

    /// Get air quality doc
    const db = admin.firestore();
    const docRef = db.collection("air_quality").doc("current");
    await docRef.update(doc);

    res.send(`global : ${globalUAQI}`);
});


/// SCHEDULED UPDATE EVERY DAY
export const scheduledGetAirPollution = region('us-west1').runWith({
    serviceAccount: 'googlewallet@mgame-8c88b.iam.gserviceaccount.com'
}).pubsub
    .schedule('0 12 * * *')
    .timeZone('America/New_York')
    .onRun(async (context) => {

        const targetAudience = 'https://us-west1-mgame-8c88b.cloudfunctions.net/getAirPollution';
        const url = targetAudience;
        const auth = new GoogleAuth();

        const client = await auth.getIdTokenClient(targetAudience);

        const res = await client.request({ url });

        return null;
    });