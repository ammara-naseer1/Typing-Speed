-- Run this once to set up the database
-- psql -U postgres -d typing_speed -f db/schema.sql

CREATE TABLE IF NOT EXISTS exercises (
  id        SERIAL PRIMARY KEY,
  title     TEXT NOT NULL,
  language  TEXT NOT NULL DEFAULT 'python',
  snippet   TEXT NOT NULL,
  difficulty TEXT NOT NULL DEFAULT 'easy' -- easy | medium | hard
);

CREATE TABLE IF NOT EXISTS results (
  id          SERIAL PRIMARY KEY,
  exercise_id INTEGER REFERENCES exercises(id) ON DELETE SET NULL,
  wpm         NUMERIC(6,2) NOT NULL,
  accuracy    NUMERIC(5,2) NOT NULL,
  errors      INTEGER NOT NULL DEFAULT 0,
  duration_ms INTEGER NOT NULL,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Seed exercises
INSERT INTO exercises (title, language, snippet, difficulty) VALUES
('Hello World',       'python',     'def hello_world():
    print(''Hello, World!'')',       'easy'),
('For Loop',          'python',     'for i in range(10):
    print(i)',                        'easy'),
('Fibonacci',         'python',     'def fibonacci(n):
    a, b = 0, 1
    for _ in range(n):
        print(a, end='', '')
        a, b = b, a + b',            'medium'),
('Arrow Function',    'javascript', 'const greet = (name) => {
    return `Hello, ${name}!`;
};',                                  'easy'),
('Fetch API',         'javascript', 'async function getData(url) {
    const res = await fetch(url);
    const data = await res.json();
    return data;
}',                                   'medium'),
('Express Route',     'javascript', 'app.get(''/users/:id'', async (req, res) => {
    const user = await db.findById(req.params.id);
    if (!user) return res.status(404).json({ error: ''Not found'' });
    res.json(user);
});',                                 'hard'),
('SQL Select',        'sql',        'SELECT u.name, COUNT(o.id) AS orders
FROM users u
LEFT JOIN orders o ON o.user_id = u.id
WHERE u.active = true
GROUP BY u.id
ORDER BY orders DESC;',              'medium'),
('Bash Script',       'bash',       '#!/bin/bash
for file in *.log; do
    echo "Processing $file"
    grep -i "error" "$file" >> errors.txt
done',                                'medium'),
('TypeScript Interface', 'typescript', 'interface User {
    id: number;
    name: string;
    email: string;
    createdAt: Date;
}

function formatUser(user: User): string {
    return `${user.name} <${user.email}>`;
}',                                   'hard')
ON CONFLICT DO NOTHING;
