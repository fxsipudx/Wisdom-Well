import dotenv from "dotenv";
import OpenAI from "openai";
import { onCall } from "firebase-functions/v2/https";

dotenv.config(); // Load environment variables

// Initialize OpenAI API with the key from .env
const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY,
});

export const fetchBibleAnswer = onCall(async (data, context) => {
  console.log("Function invoked with data:", data); // Debug incoming data

  // Validate API key
  if (!process.env.OPENAI_API_KEY) {
    console.error("OpenAI API Key is not configured");
    throw new Error("OpenAI API Key is not configured");
  }

  // Extract query and language from incoming data
  const query = data?.data?.query;
  const language = data?.data?.language || "English";

  if (!query) {
    console.error("Query is missing or empty"); // Debug missing query
    throw new Error("The query cannot be empty.");
  }

  try {
    console.log(`Calling OpenAI API with query: "${query}" and language: "${language}"`);

    // Call OpenAI API with the provided query and language
    const completion = await openai.chat.completions.create({
      model: "gpt-3.5-turbo",
      messages: [
        {
          role: "system",
          content:
            "You are a knowledgeable biblical scholar who provides insightful, compassionate, and accurate explanations of biblical passages and concepts.",
        },
        {
          role: "user",
          content: `Provide a biblical explanation for: "${query}" in ${language}. Ensure the response is concise, clear, and spiritually meaningful.`,
        },
      ],
      max_tokens: 150,
      temperature: 0.7,
    });

    // Extract and trim the response
    const answer = completion.choices[0].message.content.trim();
    console.log("OpenAI API response:", answer); // Debug API response
    return { result: answer };
  } catch (error) {
    console.error("Error calling OpenAI API:", error); // Debug full error
    throw new Error(`Unable to process the query: ${error.message}`);
  }
});