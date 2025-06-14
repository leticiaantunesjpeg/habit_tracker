import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import * as admin from "firebase-admin";

admin.initializeApp();
const firestore = admin.firestore();

interface HabitSuggestion {
  name: string;
  frequency: string;
  category?: string;
}

export const getSuggestions = functions.https.onRequest(async (request, response) => {
  try {
    const query = request.query.q as string || "";
    const limit = parseInt(request.query.limit as string || "10");
    const frequency = request.query.frequency as string;
    
    console.info(`Consulta de sugestão recebida: ${query}, frequência: ${frequency}`);
    
    if (!query || query.trim() === "") {
      return response.status(200).json([]);
    }
    
    const modelDoc = await firestore.collection("ml_models").doc("habit_suggestion_model").get();
    
    if (!modelDoc.exists) {
      console.error("Modelo de sugestão não encontrado no Firestore");
      return response.status(404).json({
        error: "Modelo de sugestão não encontrado",
      });
    }
    
    const modelData = modelDoc.data();
    let suggestions: string[] = modelData?.suggestions || [];
    
    const queryLower = query.toLowerCase();
    let filteredSuggestions = suggestions
      .filter(suggestion => suggestion.toLowerCase().includes(queryLower));
      
    if (frequency) {
      filteredSuggestions = filteredSuggestions.filter(
        suggestion => suggestion.toLowerCase().includes(frequency.toLowerCase())
      );
    }
    
    filteredSuggestions = filteredSuggestions.slice(0, limit);
    
    if (filteredSuggestions.length === 0 && query.length > 3) {
      await firestore.collection("unmatched_queries").add({
        query: query,
        frequency: frequency || "",
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
      });
      
      console.info(`Query não correspondida registrada: ${query}`);
    }
    
    return response.status(200).json(filteredSuggestions);
  } catch (error) {
    console.error("Erro ao processar sugestões:", error);
    return response.status(500).json({
      error: "Erro ao processar a requisição de sugestões",
    });
  }
});
