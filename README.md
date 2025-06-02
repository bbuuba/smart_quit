
Problema

Renunțarea la fumat este o provocare majoră pentru mulți oameni, implicând atât aspecte fizice cât și psihologice. Mulți fumători încearcă să se lase de fumat de mai multe ori înainte de a reuși cu adevărat, iar metodele tradiționale de suport, cum ar fi plasturii de nicotină, gumele sau chiar terapiile comportamentale, nu sunt întotdeauna suficiente sau accesibile pentru toți.
De asemenea, mulți oameni nu au acces la consiliere constantă sau grupuri de suport care să îi ajute să rămână motivați. Într-un mediu unde tentatiile sunt la tot pasul, este esențial ca utilizatorii să aibă la dispoziție un instrument ușor de utilizat, care să ofere sprijin imediat și personalizat.

Soluția

SmartQuit automatizează procesul de renunțare la fumat, reducând timpul și efortul necesar pentru a obține sprijin și resurse personalizate. Aplicația înlocuiește metodele tradiționale de suport cu o interfață grafică intuitivă care permite accesul rapid la diverse funcții. Utilizatorul beneficiază de un portofel (wallet) care monitorizează economiile realizate, un cronometru care urmărește timpul trecut de la ultima țigară, și un contorizator de țigări bazat pe AI, care utilizează detectarea sunetului și monitorizarea senzorilor pentru a număra automat țigările fumate, și pentru a-l indruma pe utilizator spre a renunța la fumat. 

Funcționalitățile aplicației:

⦁	Monitorizare în timp real după gesturi si sunet.

⦁	Portofel (Wallet): Monitorizează economiile realizate prin reducerea numărului de țigări fumate.

⦁	Cronometru (Timer): Urmărește timpul trecut de la ultima țigară, ajutând utilizatorul să vizualizeze progresul în timp real.

⦁	Contorizator de țigări folosind AI: Utilizează detectarea sunetului și monitorizarea senzorilor pentru a număra automat țigările fumate.

⦁	Autentificare și înregistrare: Funcționalitate completă de login și signup folosind Firebase ca bază de date, asigurând securitatea și confidențialitatea datelor utilizatorilor.

⦁	Interfață intuitivă: Dezvoltată în Flutter, oferind o experiență fluidă și plăcută utilizatorilor.


Unelte folosite

⦁	Python: Limbajul de programare folosit pentru dezvoltarea funcționalităților de backend și AI.

⦁	Java: Utilizat pentru dezvoltarea componentelor critice de backend.

⦁	Dart: Folosit în Flutter pentru crearea interfeței grafice.

⦁	Flutter: Framework-ul folosit pentru dezvoltarea interfeței grafice.

⦁	Firebase: Baza de date folosită pentru stocarea și gestionarea datelor utilizatorilor.

⦁	TensorFlow: Biblioteca folosită pentru a implementa modelul de AI pentru detectarea sunetului.


Aplicația SmartQuit este construită pe o arhitectură robustă care integrează aceste tehnologii pentru a oferi o soluție completă și eficientă pentru renunțarea la fumat. Interfața intuitivă dezvoltată în Flutter permite utilizatorilor să acceseze rapid și ușor toate funcționalitățile aplicației, în timp ce backend-ul puternic dezvoltat în Python și Java asigură performanța și scalabilitatea necesare pentru gestionarea eficientă a datelor și funcționalităților. Utilizarea Firebase garantează securitatea și confidențialitatea datelor utilizatorilor, iar TensorFlow aduce un nivel avansat de inteligență artificială pentru monitorizarea comportamentului de fumat.
Elementele distinctive ale aplicației în comparație cu competiția
Cu SmartQuit, aducem o abordare inovatoare și eficientă în lupta împotriva fumatului, oferind utilizatorilor o soluție complet automatizată și precisă pentru monitorizarea și reducerea consumului de țigări. În contrast cu alte aplicații de renunțare la fumat care se bazează pe introducerea manuală a datelor sau estimări subiective, SmartQuit se distinge prin utilizarea tehnologiei avansate pentru a contoriza automat consumul de țigări. Folosind inteligența artificială și integrând funcționalități ale smartwatch-ului, SmartQuit detectează automat momentele în care utilizatorul fumează și înregistrează aceste date în mod precis și neinvaziv. Acest lucru oferă utilizatorilor o imagine realistă și obiectivă a obiceiurilor lor de fumat, permitându-le să ia decizii informate și să monitorizeze progresul lor în timp real. Astfel, SmartQuit se remarcă ca o soluție inovatoare și eficientă în promovarea renunțării la fumat, oferind o abordare personalizată și de încredere în sprijinul utilizatorilor în călătoria lor către o viață fără tutun.






Documentație pentru Modelul de Detecție a Clicurilor de Brichetă

Introducere

Modelul utilizează un set de date mixt, compus din sunete reale inregistrate de noi și altele generate sintetic pe baza inregistrarilor. Implementarea a fost realizată folosind TensorFlow și TensorFlow I/O pentru prelucrarea datelor audio și construcția modelului.

1. Preprocesarea Datelor Audio

1.1 Funcția load_wav_16k_mono

Această funcție încarcă fișiere audio .wav și le transformă într-un format adecvat pentru procesare ulterioară.
![image](https://github.com/user-attachments/assets/6e064c01-79b9-4546-bb4a-62413f9ebd3d)

 Citește fișierul: Folosește tf.io.read_file pentru a citi conținutul fișierului.
⦁	Decodează și ajustează canalul: Utilizează tf.audio.decode_wav pentru a decodifica fișierul audio în format mono.
⦁	Resamplează: Eșantionarea audio este ajustată la 16 kHz folosind tfio.audio.resample.

1.2 Funcția add_noise

Această funcție adaugă zgomot alb la semnalul audio pentru a crește robustețea modelului.
![image](https://github.com/user-attachments/assets/fa530c7a-4023-492f-857b-66ab91b0c72a) 
⦁	Generare zgomot: Creează  normal distribuit.
⦁	Adăugare zgomot: Zgomotul generat este adăugat la semnalul original, pentru a varia filele

1.3 Funcția preprocess

Funcția combină funcțiile anterioare și efectuează transformarea finală în spectrogramă.
![image](https://github.com/user-attachments/assets/85ed4f8d-4576-448b-9f5a-3e252562ff5b) 
⦁	Încărcare și tăiere: Încărcă și trunchiază semnalul audio la 1 secundă (16,000 mostre).
⦁	Adăugare zgomot: Aplică zgomot pentru augmentare.
⦁	Zero-padding: Completează cu zerouri pentru a se asigura că toate semnalele audio au aceeași lungime.
⦁	Transformare STFT: Convertește semnalul în spectrogramă folosind Short-time Fourier transform (STFT).
⦁	Redimensionare: Redimensionează spectrograma la 256x256 pixeli.

2. Pregătirea Dataset-ului

 ![image](https://github.com/user-attachments/assets/c7049e58-67c6-4d02-9b8a-84d5e87adec3)
⦁	Definire căi: POS și NEG sunt directoare ce conțin fișierele audio cu clicuri și, respectiv, fără clicuri.
⦁	Crearea dataset-urilor: Utilizează tf.data.Dataset.list_files pentru a citi fișierele și map pentru a asocia etichete (1 pentru clicuri, 0 pentru non-clicuri).
⦁	Combinare și preprocesare: Dataset-urile sunt combinate și fiecare fișier este preprocesat.
⦁	Optimizări: Folosește cache, shuffle, batch și prefetch pentru optimizarea procesului de antrenament.

3. Construirea și Antrenarea Modelului

3.1 Definirea modelului

Modelul este un CNN simplu pentru clasificarea spectrogramelor.

![image](https://github.com/user-attachments/assets/c11cfee7-b060-4b69-ad4e-1eceb4a9cf44) 
⦁	Arhitectură: Constă în două straturi convoluționale urmate de un strat complet conectat și un strat de ieșire. Straturile convolutionale ajuta la invatarea de catre model a caracteristicilor complexe din imagine, cele de tipul Dense() ajuta la 
⦁	Activări și regularizare: Folosește relu pentru activări și Dropout pentru a preveni overfitting-ul.

3.2 Compilarea și antrenarea modelului

![image](https://github.com/user-attachments/assets/fb7d56e8-2eb9-4de3-af5c-b1068575ccfe)
⦁	Optimizator și funcție de pierdere: adam pentru optimizare și binary_crossentropy ca funcție de pierdere.
⦁	Antrenare: Antrenează modelul pe setul de date de antrenament, utilizând un set de validare pentru monitorizare.

3.3 Salvarea modelului

![image](https://github.com/user-attachments/assets/728c0e1f-66a7-4b65-b0cd-c1ca177978db)
Modelul antrenat este salvat într-un fișier .h5, si trecut printr-un alt script in python ce il converteste intr-un model de tip .tflite, pentru a-l putea integra in codul din java.




Documentație pentru Algoritmul de Detectare a Fumatului pe Bază de Senzori de Smartwatch

Introducere

Algoritm destinat detectării poziției mâinii în timpul fumatului utilizând date de la senzorii unui smartwatch. Algoritmul folosește date de la accelerometru și magnetometru pentru a determina orientarea mâinii utilizatorului.

1. Monitorizarea și Procesarea Datelor Senzoriale

1.1 Funcția onSensorChanged

Această funcție este apelată de fiecare dată când se schimbă datele unui senzor.
![image](https://github.com/user-attachments/assets/e7598a12-87c4-415c-a8f4-527511918371)
⦁	Verificarea tipului de senzor: Se verifică dacă evenimentul provine de la accelerometru sau magnetometru și se actualizează valorile corespunzătoare (mGravity și mGeomagnetic).
⦁	Determinarea stării: Dacă ambele seturi de date (accelerometru și magnetometru) sunt disponibile, se apelează funcția sensorsFunction pentru a determina dacă mâna se află în poziția de fumat.
⦁	Actualizarea stării: Pe baza rezultatului (ans), se actualizează starea și se trimit datele corespunzătoare ("1" pentru poziția de fumat și "0" pentru lipsa acestei poziții).

2. Algoritmul de Determinare a Poziției Mâinii

2.1 Funcția sensorsFunction

Această funcție calculează matricea de rotație și determină orientarea dispozitivului.
![image](https://github.com/user-attachments/assets/677e9b49-5745-4766-98ad-ef2438d12eee) 
⦁	Calcularea matricei de rotație: Folosește SensorManager.getRotationMatrix pentru a calcula matricea de rotație R și matricea intermediară I pe baza valorilor senzorilor de gravitație și magnetometru.
⦁	Determinarea orientării: Folosește SensorManager.getOrientation pentru a calcula azimutul, pitch-ul și roll-ul dispozitivului.
⦁	Detectarea poziției de fumat: Verifică dacă pitch și roll se află în intervalele specificate pentru a determina dacă mâna se află în poziția de fumat.



.
