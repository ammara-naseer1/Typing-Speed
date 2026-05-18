const express = require('express');
const path = require('path');
require('dotenv').config();

const db = require('./db');
const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json());
app.use(express.static(path.join(__dirname, '..', 'public')));

require('dotenv').config();
console.log('DB URL:', process.env.DATABASE_URL);

// ── Exercises ────────────────────────────────────────────────────────────────

// GET /api/exercises  →  list all (id, title, language, difficulty)
app.get('/api/exercises', async (_req, res) => {
  try {
    const { rows } = await db.query(
      'SELECT id, title, language, difficulty FROM exercises ORDER BY id'
    );
    res.json(rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Database error' });
  }
});

// GET /api/exercises/random?difficulty=easy  →  one random exercise
app.get('/api/exercises/random', async (req, res) => {
  const { difficulty } = req.query;
  try {
    const params = difficulty ? [difficulty] : [];
    const where  = difficulty ? 'WHERE difficulty = $1' : '';
    const { rows } = await db.query(
      `SELECT * FROM exercises ${where} ORDER BY RANDOM() LIMIT 1`,
      params
    );
    if (!rows.length) return res.status(404).json({ error: 'No exercises found' });
    res.json(rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Database error' });
  }
});

// GET /api/exercises/:id
app.get('/api/exercises/:id', async (req, res) => {
  try {
    const { rows } = await db.query('SELECT * FROM exercises WHERE id = $1', [req.params.id]);
    if (!rows.length) return res.status(404).json({ error: 'Not found' });
    res.json(rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Database error' });
  }
});

// ── Results ──────────────────────────────────────────────────────────────────

// POST /api/results  →  save a completed attempt
//   body: { exercise_id, wpm, accuracy, errors, duration_ms }
app.post('/api/results', async (req, res) => {
  const { exercise_id, wpm, accuracy, errors, duration_ms } = req.body;

  if (wpm == null || accuracy == null || duration_ms == null) {
    return res.status(400).json({ error: 'wpm, accuracy, and duration_ms are required' });
  }

  try {
    const { rows } = await db.query(
      `INSERT INTO results (exercise_id, wpm, accuracy, errors, duration_ms)
       VALUES ($1, $2, $3, $4, $5)
       RETURNING *`,
      [exercise_id ?? null, wpm, accuracy, errors ?? 0, duration_ms]
    );
    res.status(201).json(rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Database error' });
  }
});

// GET /api/results?limit=20  →  recent results (joined with exercise title)
app.get('/api/results', async (req, res) => {
  const limit = Math.min(parseInt(req.query.limit) || 20, 100);
  try {
    const { rows } = await db.query(
      `SELECT r.id, r.wpm, r.accuracy, r.errors, r.duration_ms, r.created_at,
              e.title AS exercise_title, e.language
       FROM results r
       LEFT JOIN exercises e ON e.id = r.exercise_id
       ORDER BY r.created_at DESC
       LIMIT $1`,
      [limit]
    );
    res.json(rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Database error' });
  }
});

// GET /api/results/stats  →  all-time best, averages
app.get('/api/results/stats', async (req, res) => {
  try {
    const { rows } = await db.query(`
      SELECT
        COUNT(*)::int                          AS total_attempts,
        ROUND(MAX(wpm), 2)                     AS best_wpm,
        ROUND(AVG(wpm), 2)                     AS avg_wpm,
        ROUND(AVG(accuracy), 2)                AS avg_accuracy,
        ROUND(AVG(errors), 2)                  AS avg_errors
      FROM results
    `);
    res.json(rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Database error' });
  }
});

// ── Fallback ─────────────────────────────────────────────────────────────────
app.get('/{*path}', (_req, res) => {
    res.sendFile(path.join(__dirname, '..', 'public', 'index.html'));
});

app.listen(PORT, () => {
  console.log(`Typing Speed app running → http://localhost:${PORT}`);
});