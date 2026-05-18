# TypeSprint

A minimal, keyboard-first typing speed app for coders. Practice on real code snippets, track your WPM and accuracy, and save every run to PostgreSQL.

Built with Node.js · Express · PostgreSQL · Vanilla JS

---

## Features

- **Real code snippets** — Python, JavaScript, TypeScript, SQL, Bash
- **Live feedback** — WPM, accuracy, and error count update as you type
- **Character-level highlighting** — correct chars turn green, mistakes turn red
- **Persistent history** — every completed run is saved to the database
- **Difficulty filter** — easy, medium, or hard
- **Stats dashboard** — best WPM, averages, total runs

---

## Prerequisites

- Node.js 18+
- PostgreSQL 14+

---

## Setup

**1. Clone the repo**

```bash
git clone https://github.com/your-username/typing-speed.git
cd typing-speed
```

**2. Install dependencies**

```bash
npm install
```

**3. Create the database**

```bash
createdb typing_speed
```

**4. Configure environment**

```bash
cp .env.example .env
```

Open `.env` and set your connection string:

```
DATABASE_URL=postgresql://postgres:password@localhost:5432/typing_speed
PORT=3000
```

**5. Run migrations and seed data**

```bash
npm run db:setup
```

This creates the `exercises` and `results` tables and inserts the starter snippets.

**6. Start the server**

```bash
npm start          # production
npm run dev        # dev with auto-restart (Node 18+ --watch)
```

Open [http://localhost:3000](http://localhost:3000)

---

## Project Structure

```
typing-speed/
├── db/
│   └── schema.sql        # Table definitions + seed exercises
├── public/
│   └── index.html        # Single-page frontend (vanilla JS, no build step)
├── src/
│   ├── db.js             # PostgreSQL connection pool
│   └── server.js         # Express app + all API routes
├── .env.example
├── package.json
└── README.md
```

---

## API Reference

| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/api/exercises` | List all exercises |
| `GET` | `/api/exercises/random` | Random exercise (optional `?difficulty=easy\|medium\|hard`) |
| `GET` | `/api/exercises/:id` | Single exercise by ID |
| `POST` | `/api/results` | Save a completed run |
| `GET` | `/api/results` | Recent results (optional `?limit=20`) |
| `GET` | `/api/results/stats` | Aggregate stats (best WPM, averages) |

### POST /api/results

```json
{
  "exercise_id": 1,
  "wpm": 72.5,
  "accuracy": 96.3,
  "errors": 2,
  "duration_ms": 14200
}
```

---

## Adding Exercises

Insert directly into the database:

```sql
INSERT INTO exercises (title, language, snippet, difficulty)
VALUES (
  'Array Destructuring',
  'javascript',
  'const [first, ...rest] = [1, 2, 3, 4];
console.log(first); // 1
console.log(rest);  // [2, 3, 4]',
  'easy'
);
```

Valid values for `difficulty`: `easy`, `medium`, `hard`.  
Valid values for `language`: any string — it's displayed as a badge in the UI.

---