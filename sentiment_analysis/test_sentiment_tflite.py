import tensorflow as tf
import numpy as np
import pickle
from tensorflow.keras.preprocessing.sequence import pad_sequences

# -------------------------------
# Load tokenizer
# -------------------------------
with open("tokenizer.pkl", "rb") as f:
    tokenizer = pickle.load(f)

# -------------------------------
# Load TFLite model
# -------------------------------
interpreter = tf.lite.Interpreter(model_path="sentiment_model.tflite")
interpreter.allocate_tensors()

input_details = interpreter.get_input_details()
output_details = interpreter.get_output_details()

# -------------------------------
# Function to predict sentiment
# -------------------------------
def predict_sentiment(text_list, max_len=50):
    # Convert text to sequences
    sequences = tokenizer.texts_to_sequences(text_list)
    padded = pad_sequences(sequences, maxlen=max_len)

    # Run TFLite inference
    interpreter.set_tensor(input_details[0]['index'], padded.astype(np.float32))
    interpreter.invoke()
    output_data = interpreter.get_tensor(output_details[0]['index'])
    
    predictions = []
    for i, out in enumerate(output_data):
        label = np.argmax(out)
        confidence = out[label]
        predictions.append({
            "text": text_list[i],
            "predicted_label": label,
            "confidence": float(confidence)
        })
    return predictions

# -------------------------------
# Test
# -------------------------------
sample_texts = [
    "I love this app, it is amazing!",
    "I am so frustrated with this feature.",
    "The update is okay, nothing special."
]

results = predict_sentiment(sample_texts)
for r in results:
    print(f"Message: {r['text']}")
    print(f"Prediction: {r['predicted_label']}, Confidence: {r['confidence']:.2f}")
    print("-"*50)
