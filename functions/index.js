const functions = require("firebase-functions");
const admin = require("firebase-admin");
const { OpenAI } = require("openai");

admin.initializeApp();
const openai = new OpenAI({ apiKey: "YOUR_OPENAI_API_KEY" });

exports.getAIStylistAdvice = functions.https.onCall(async (data, context) => {
    const { styleProfile } = data; // e.g. ["Elegant", "Bold"]
    
    try {
        const prompt = `You are a fashion stylist for Trendora. Based on the style profile: ${styleProfile.join(", ")}, recommend an outfit (Dress, Shoes, Bag). Return a JSON object with 'outfitName', 'matchPercentage', and 'items' (name, price).`;
        
        const response = await openai.chat.completions.create({
            model: "gpt-4o",
            messages: [{ role: "user", content: prompt }],
            response_format: { type: "json_object" }
        });

        return JSON.parse(response.choices[0].message.content);
    } catch (error) {
        throw new functions.https.HttpsError("internal", error.message);
    }
});