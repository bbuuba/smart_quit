import numpy as np
import tensorflow as tf
from os.path import dirname, join
filename = join(dirname(__file__), "smaller-model.tflite")
interpreter = tf.lite.Interpreter(model_path=filename)
interpreter.allocate_tensors()

def preprocess_audio(wav):
    # Spectrogram parameters
    frame_length = 320
    frame_step = 32
    n_fft = 512  # Choose n_fft to be greater than or equal to frame_length

    # Compute the number of frames
    num_frames = (len(wav) - frame_length) // frame_step + 1
    if (len(wav) - frame_length) % frame_step != 0:
        num_frames += 1

    # Compute the spectrogram
    stft_matrix = np.empty((num_frames, 257), dtype=np.complex64)
    for i in range(num_frames):
        start = i * frame_step
        end = min(start + frame_length, len(wav))
        frame = wav[start:end]
        padded_frame = np.pad(frame, (0, frame_length - len(frame)), mode='constant')
        stft_matrix[i, :] = np.fft.fft(padded_frame, n=n_fft)[:257]  # Corrected FFT size

    spectrogram = np.abs(stft_matrix)

    # Add batch and channel dimensions
    spectrogram = np.expand_dims(spectrogram, axis=0)
    spectrogram = np.expand_dims(spectrogram, axis=-1)
    spectrogram = spectrogram.astype(np.float32)

    return spectrogram


def predict_chunks(wav, chunk_size=16000):
    wav = wav.astype(np.float32)
    for i in range(0, len(wav), chunk_size):
        chunk = wav[i:i+chunk_size]
        #print(len(chunk), chunk_size)
        spectrogram = preprocess_audio(chunk)
        # Run inference
        input_details = interpreter.get_input_details()
        output_details = interpreter.get_output_details()
        interpreter.set_tensor(input_details[0]['index'], spectrogram)
        interpreter.invoke()
        prediction = interpreter.get_tensor(output_details[0]['index'])

    return prediction


# Callback function for processing audio stream
def callback(in_data):
    #return len(in_data)
    new_data = bytes(in_data)
    audio_data = np.frombuffer(new_data, dtype=np.int32)
    if np.isnan(audio_data).any():
        return "duten pizda matii"
    audio_data_float32 = audio_data.astype(np.float32) / np.iinfo(np.int32).max
    prediction = predict_chunks(audio_data_float32)
    return prediction[0][0]