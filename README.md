🚉 Clean Train Station Score Card App
A Flutter app for digital entry and submission of Indian Railways “Clean Train Station” score cards, replicating the official paper format. Supervisors can fill inspection details, mark scores for each activity and coach, and submit data directly to a webhook for record-keeping or further processing.

✨ Features
✅ Editable meta fields (Work Order No, Date, Supervisor name, etc.)
✅ Table UI matching the official score card format
✅ Dropdowns (0–10) in every relevant cell
✅ Text and layout closely matching the paper form
✅ Data submission as JSON to a configurable webhook (e.g., Webhook.site)
✅ Responsive and compact design for mobile devices

🚀 Getting Started
Prerequisites
Flutter (latest stable version)

Internet connection (for webhook submission)

Installation
Clone the repository

bash
Copy
Edit
git clone https://github.com/sayandeep-coder/flutter-form
cd flutter-form
Install dependencies

bash
Copy
Edit
flutter pub get
Run the app

bash
Copy
Edit
flutter run
📲 Usage
Fill in meta fields

W.O.No, Date, Name of Contractor, etc.

Select scores

For each activity and coach, choose a score (0–10) from the dropdowns.

Submit

Tap the Submit button at the bottom.

Data is sent as JSON to the configured webhook URL.

You will see a success or failure message.

🗂️ Project Structure
bash
Copy
Edit
lib/
 ┣ screens/
 ┃ ┗ score_card_screen.dart  # Main UI and logic for the score card
 ┣ main.dart                 # App entry point
pubspec.yaml                 # Project dependencies
⚙️ Customization
Webhook URL

Edit the URL in the _submit function within score_card_screen.dart.

Activities

Modify the activities list in score_card_screen.dart to add or update activities.

📄 License
This project is for demonstration and internal use only.
For official deployment, please consult the Indian Railways IT policy.


