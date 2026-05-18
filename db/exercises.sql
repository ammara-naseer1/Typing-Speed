-- Additional exercises -- run with:
-- psql postgresql://amara@localhost:5432/typing_speed -f db/exercises.sql

INSERT INTO exercises (title, language, snippet, difficulty) VALUES

-- JavaScript
('Promise Chain',         'javascript', 'fetch(''/api/data'')
  .then(res => res.json())
  .then(data => console.log(data))
  .catch(err => console.error(err));',                                          'easy'),

('Debounce Function',     'javascript', 'function debounce(fn, delay) {
  let timer;
  return function (...args) {
    clearTimeout(timer);
    timer = setTimeout(() => fn.apply(this, args), delay);
  };
}',                                                                             'medium'),

('Event Emitter',         'javascript', 'const events = {};

function on(event, listener) {
  (events[event] ||= []).push(listener);
}

function emit(event, ...args) {
  (events[event] || []).forEach(fn => fn(...args));
}',                                                                             'medium'),

('Binary Search',         'javascript', 'function binarySearch(arr, target) {
  let lo = 0, hi = arr.length - 1;
  while (lo <= hi) {
    const mid = Math.floor((lo + hi) / 2);
    if (arr[mid] === target) return mid;
    arr[mid] < target ? (lo = mid + 1) : (hi = mid - 1);
  }
  return -1;
}',                                                                             'medium'),

('Flatten Nested Array',  'javascript', 'function flatten(arr) {
  return arr.reduce((acc, val) =>
    Array.isArray(val)
      ? acc.concat(flatten(val))
      : acc.concat(val),
  []);
}',                                                                             'hard'),

-- TypeScript
('Generic Stack',         'typescript', 'class Stack<T> {
  private items: T[] = [];

  push(item: T): void {
    this.items.push(item);
  }

  pop(): T | undefined {
    return this.items.pop();
  }

  peek(): T | undefined {
    return this.items[this.items.length - 1];
  }
}',                                                                             'medium'),

('Readonly Config',       'typescript', 'type Config = {
  readonly host: string;
  readonly port: number;
  readonly debug: boolean;
};

function createConfig(overrides: Partial<Config>): Config {
  return { host: ''localhost'', port: 3000, debug: false, ...overrides };
}',                                                                             'medium'),

('Discriminated Union',   'typescript', 'type Shape =
  | { kind: ''circle'';    radius: number }
  | { kind: ''rectangle''; width: number; height: number };

function area(shape: Shape): number {
  if (shape.kind === ''circle'') return Math.PI * shape.radius ** 2;
  return shape.width * shape.height;
}',                                                                             'hard'),

-- Python
('List Comprehension',    'python',     'matrix = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
transposed = [[row[i] for row in matrix] for i in range(3)]
print(transposed)',                                                             'easy'),

('Decorator',             'python',     'import time

def timer(func):
    def wrapper(*args, **kwargs):
        start = time.time()
        result = func(*args, **kwargs)
        print(f"{func.__name__} took {time.time() - start:.4f}s")
        return result
    return wrapper',                                                            'medium'),

('Context Manager',       'python',     'class ManagedFile:
    def __init__(self, path, mode):
        self.path = path
        self.mode = mode

    def __enter__(self):
        self.file = open(self.path, self.mode)
        return self.file

    def __exit__(self, exc_type, exc_val, exc_tb):
        self.file.close()',                                                     'medium'),

('Generator',             'python',     'def infinite_counter(start=0, step=1):
    n = start
    while True:
        yield n
        n += step

counter = infinite_counter(start=10, step=5)
print([next(counter) for _ in range(5)])',                                      'medium'),

('Merge Sort',            'python',     'def merge_sort(arr):
    if len(arr) <= 1:
        return arr
    mid = len(arr) // 2
    left = merge_sort(arr[:mid])
    right = merge_sort(arr[mid:])
    result = []
    i = j = 0
    while i < len(left) and j < len(right):
        if left[i] < right[j]:
            result.append(left[i]); i += 1
        else:
            result.append(right[j]); j += 1
    return result + left[i:] + right[j:]',                                     'hard'),

-- SQL
('Window Function',       'sql',        'SELECT
  employee_id,
  department,
  salary,
  RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS rank,
  AVG(salary) OVER (PARTITION BY department) AS dept_avg
FROM employees;',                                                               'medium'),

('CTE with Recursion',    'sql',        'WITH RECURSIVE subordinates AS (
  SELECT id, name, manager_id
  FROM employees
  WHERE id = 1
  UNION ALL
  SELECT e.id, e.name, e.manager_id
  FROM employees e
  JOIN subordinates s ON s.id = e.manager_id
)
SELECT * FROM subordinates;',                                                   'hard'),

('Upsert',                'sql',        'INSERT INTO users (id, email, updated_at)
VALUES (1, ''amara@example.com'', NOW())
ON CONFLICT (id)
DO UPDATE SET
  email = EXCLUDED.email,
  updated_at = EXCLUDED.updated_at;',                                           'medium'),

-- Bash
('Retry Loop',            'bash',       '#!/bin/bash
MAX=5
for i in $(seq 1 $MAX); do
  echo "Attempt $i..."
  curl -sf https://example.com && break
  [ $i -eq $MAX ] && echo "Failed after $MAX attempts" && exit 1
  sleep 2
done',                                                                          'medium'),

('Parse Args',            'bash',       '#!/bin/bash
while [[ "$#" -gt 0 ]]; do
  case $1 in
    -e|--env)  ENV="$2";  shift ;;
    -p|--port) PORT="$2"; shift ;;
    *) echo "Unknown: $1"; exit 1 ;;
  esac
  shift
done
echo "env=$ENV port=$PORT"',                                                    'hard'),

-- Go
('HTTP Handler',          'go',         'func helloHandler(w http.ResponseWriter, r *http.Request) {
    if r.Method != http.MethodGet {
        http.Error(w, "method not allowed", http.StatusMethodNotAllowed)
        return
    }
    w.Header().Set("Content-Type", "application/json")
    json.NewEncoder(w).Encode(map[string]string{"message": "hello"})
}',                                                                             'medium'),

('Goroutine with WaitGroup', 'go',      'func main() {
    var wg sync.WaitGroup
    for i := 0; i < 5; i++ {
        wg.Add(1)
        go func(id int) {
            defer wg.Done()
            fmt.Printf("worker %d done\n", id)
        }(i)
    }
    wg.Wait()
}',                                                                             'hard'),

-- Rust
('Pattern Matching',      'rust',       'enum Message {
    Quit,
    Move { x: i32, y: i32 },
    Write(String),
}

fn handle(msg: Message) {
    match msg {
        Message::Quit => println!("quit"),
        Message::Move { x, y } => println!("move to {x},{y}"),
        Message::Write(s) => println!("write: {s}"),
    }
}',                                                                             'hard'),

('Result Chaining',       'rust',       'use std::num::ParseIntError;

fn double_str(s: &str) -> Result<i32, ParseIntError> {
    s.trim().parse::<i32>().map(|n| n * 2)
}

fn main() {
    println!("{:?}", double_str("  21  "));
    println!("{:?}", double_str("abc"));
}',                                                                             'hard')

ON CONFLICT DO NOTHING;
