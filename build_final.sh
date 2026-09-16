#!/bin/bash
cat << 'HTML_EOF' > /app/prepx_Anatomy.html
<!DOCTYPE html>
<html lang="en" class="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Marrow PYQ - Anatomy</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            darkMode: 'class',
            theme: {
                extend: {
                    colors: {
                        primary: '#3b82f6',
                        success: '#22c55e',
                        warning: '#eab308',
                        danger: '#ef4444'
                    }
                }
            }
        }
    </script>
    <script src="https://www.gstatic.com/firebasejs/9.23.0/firebase-app-compat.js"></script>
    <script src="https://www.gstatic.com/firebasejs/9.23.0/firebase-auth-compat.js"></script>
    <script src="https://www.gstatic.com/firebasejs/9.23.0/firebase-firestore-compat.js"></script>
    <style>
        body { margin: 0; padding: 0; height: 100vh; display: flex; flex-direction: column; overflow: hidden; background-color: #f3f4f6; color: #1f2937; }
        .dark body { background-color: #111827; color: #f9fafb; }
        .screen { display: none; height: 100%; flex-direction: column; overflow-y: auto; }
        .screen.active { display: flex; }
        .screen.flex-row.active { flex-direction: row; }
        .nav-grid-btn { width: 36px; height: 36px; border-radius: 8px; display: flex; align-items: center; justify-content: center; font-weight: bold; cursor: pointer; border: 1px solid #d1d5db; transition: all 0.2s; }
        .dark .nav-grid-btn { border-color: #4b5563; }
        .status-unanswered { background-color: #f3f4f6; color: #374151; }
        .dark .status-unanswered { background-color: #374151; color: #f9fafb; }
        .status-answered { background-color: #22c55e; color: white; border-color: #22c55e; }
        .status-marked { border: 2px solid #eab308; }
        .status-bookmarked { border-bottom: 4px solid #3b82f6; }
        .option-btn { width: 100%; text-align: left; padding: 12px; border-radius: 8px; border: 1px solid #d1d5db; margin-bottom: 8px; cursor: pointer; transition: all 0.2s; }
        .dark .option-btn { border-color: #4b5563; background-color: #1f2937; }
        .option-btn:hover { background-color: #e5e7eb; }
        .dark .option-btn:hover { background-color: #374151; }
        .option-selected { border-color: #3b82f6; background-color: #eff6ff; }
        .dark .option-selected { background-color: rgba(59, 130, 246, 0.2); }
        .option-correct { border-color: #22c55e; background-color: #f0fdf4; }
        .dark .option-correct { background-color: rgba(34, 197, 94, 0.2); }
        .option-incorrect { border-color: #ef4444; background-color: #fef2f2; }
        .dark .option-incorrect { background-color: rgba(239, 68, 68, 0.2); }
    </style>
</head>
<body>
    <header class="bg-white dark:bg-gray-800 shadow-sm px-4 py-3 flex justify-between items-center z-10 sticky top-0">
        <h1 class="text-xl font-bold text-gray-800 dark:text-white" id="header-title">Marrow PYQ</h1>
        <div class="flex items-center space-x-3">
            <button id="btn-theme" class="p-2 rounded-full hover:bg-gray-200 dark:hover:bg-gray-700" title="Toggle Dark Mode">
                <svg class="w-5 h-5 hidden dark:block text-yellow-300" fill="currentColor" viewBox="0 0 20 20"><path d="M10 2a1 1 0 011 1v1a1 1 0 11-2 0V3a1 1 0 011-1zm4 8a4 4 0 11-8 0 4 4 0 018 0zm-.464 4.95l.707.707a1 1 0 001.414-1.414l-.707-.707a1 1 0 00-1.414 1.414zm2.12-10.607a1 1 0 010 1.414l-.706.707a1 1 0 11-1.414-1.414l.707-.707a1 1 0 011.414 0zM17 11a1 1 0 100-2h-1a1 1 0 100 2h1zm-7 4a1 1 0 011 1v1a1 1 0 11-2 0v-1a1 1 0 011-1zM5.05 6.464A1 1 0 106.465 5.05l-.708-.707a1 1 0 00-1.414 1.414l.707.707zm1.414 8.486l-.707.707a1 1 0 01-1.414-1.414l.707-.707a1 1 0 011.414 1.414zM4 11a1 1 0 100-2H3a1 1 0 000 2h1z" fill-rule="evenodd" clip-rule="evenodd"></path></svg>
                <svg class="w-5 h-5 block dark:hidden text-gray-600" fill="currentColor" viewBox="0 0 20 20"><path d="M17.293 13.293A8 8 0 016.707 2.707a8.001 8.001 0 1010.586 10.586z"></path></svg>
            </button>
            <button id="btn-sync" class="p-2 rounded-full hover:bg-gray-200 dark:hover:bg-gray-700 hidden" title="Sync Progress">
                <svg class="w-5 h-5 text-blue-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"></path></svg>
            </button>
            <button id="btn-logout" class="text-sm font-medium text-red-500 hover:text-red-600 hidden">Logout</button>
        </div>
    </header>

    <div id="auth-screen" class="screen active justify-center items-center p-4">
        <div class="bg-white dark:bg-gray-800 p-8 rounded-xl shadow-lg max-w-md w-full">
            <h2 class="text-2xl font-bold text-center mb-6">Marrow PYQ</h2>
            <div id="auth-error" class="bg-red-100 text-red-700 p-3 rounded-md mb-4 hidden text-sm"></div>
            <form id="auth-form" class="space-y-4">
                <div><label class="block text-sm font-medium mb-1">Email</label><input type="email" id="auth-email" class="w-full px-4 py-2 border rounded-md dark:bg-gray-700 dark:border-gray-600 focus:outline-none focus:ring-2 focus:ring-blue-500" required></div>
                <div><label class="block text-sm font-medium mb-1">Password</label><input type="password" id="auth-password" class="w-full px-4 py-2 border rounded-md dark:bg-gray-700 dark:border-gray-600 focus:outline-none focus:ring-2 focus:ring-blue-500" required></div>
                <button type="submit" id="btn-auth-submit" class="w-full bg-blue-600 text-white font-bold py-2 px-4 rounded-md hover:bg-blue-700 transition">Login</button>
            </form>
            <div class="mt-4 text-center"><button id="btn-auth-toggle" class="text-blue-500 text-sm hover:underline">Need an account? Sign up</button></div>
        </div>
    </div>

    <div id="dashboard-screen" class="screen p-4 md:p-8">
        <div class="max-w-7xl mx-auto w-full">
            <h2 class="text-2xl font-bold mb-6">Available Tests</h2>
            <div id="dashboard-grid" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4"></div>
        </div>
    </div>

    <div id="instructions-screen" class="screen p-4 justify-center items-center">
        <div class="bg-white dark:bg-gray-800 p-8 rounded-xl shadow-lg max-w-2xl w-full">
            <h2 class="text-2xl font-bold mb-4" id="inst-title">Test Instructions</h2>
            <div class="space-y-4 mb-8 text-gray-700 dark:text-gray-300">
                <p><strong>Rules:</strong></p>
                <ul class="list-disc pl-5 space-y-2">
                    <li>The test is timed based on the number of questions.</li>
                    <li>You can navigate between questions using the grid or Next/Prev buttons.</li>
                    <li>You can mark questions for review.</li>
                    <li>The test will auto-submit when the timer ends.</li>
                </ul>
            </div>
            <div class="flex justify-between items-center border-t dark:border-gray-700 pt-4">
                <div><span class="text-gray-500 dark:text-gray-400">Questions: <span id="inst-q-count" class="font-bold text-gray-900 dark:text-white"></span></span></div>
                <div class="space-x-2">
                    <button id="btn-inst-back" class="px-4 py-2 border rounded-md hover:bg-gray-100 dark:hover:bg-gray-700">Back</button>
                    <button id="btn-inst-start" class="px-6 py-2 bg-blue-600 text-white font-bold rounded-md hover:bg-blue-700">Start Test</button>
                </div>
            </div>
        </div>
    </div>

    <div id="quiz-screen" class="screen flex-row">
        <div class="flex-1 flex flex-col h-full overflow-hidden">
            <div class="bg-white dark:bg-gray-800 border-b dark:border-gray-700 px-4 py-3 flex justify-between items-center shrink-0">
                <div class="font-bold" id="quiz-q-num">Question 1/X</div>
                <div id="quiz-timer" class="font-mono text-lg font-bold">00:00</div>
                <button id="btn-quiz-submit" class="bg-green-500 hover:bg-green-600 text-white px-4 py-1.5 rounded text-sm font-bold">Submit</button>
            </div>
            <div class="flex-1 overflow-y-auto p-4 md:p-8">
                <div class="max-w-3xl mx-auto">
                    <div id="quiz-q-text" class="text-lg mb-6 font-medium"></div>
                    <div id="quiz-q-media" class="mb-6 hidden"></div>
                    <div id="quiz-options" class="space-y-3"></div>
                </div>
            </div>
            <div class="bg-white dark:bg-gray-800 border-t dark:border-gray-700 px-4 py-3 flex justify-between items-center shrink-0">
                <button id="btn-quiz-mark" class="text-yellow-600 dark:text-yellow-400 font-medium px-3 py-2 rounded hover:bg-yellow-50 dark:hover:bg-gray-700 flex items-center space-x-1">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 5a2 2 0 012-2h10a2 2 0 012 2v16l-7-3.5L5 21V5z"></path></svg>
                    <span>Mark</span>
                </button>
                <div class="flex space-x-2">
                    <button id="btn-quiz-prev" class="px-4 py-2 border dark:border-gray-600 rounded disabled:opacity-50 hover:bg-gray-50 dark:hover:bg-gray-700">Previous</button>
                    <button id="btn-quiz-next" class="px-4 py-2 bg-blue-600 text-white font-bold rounded hover:bg-blue-700">Next</button>
                </div>
            </div>
        </div>
        <div id="quiz-nav-panel" class="w-72 bg-white dark:bg-gray-800 border-l dark:border-gray-700 flex flex-col shrink-0 hidden md:flex">
            <div class="p-4 border-b dark:border-gray-700">
                <h3 class="font-bold mb-2">Question Navigation</h3>
            </div>
            <div class="flex-1 overflow-y-auto p-4">
                <div id="quiz-nav-grid" class="flex flex-wrap gap-2"></div>
            </div>
        </div>
    </div>

    <div id="results-screen" class="screen p-4 md:p-8 justify-center">
        <div class="max-w-3xl mx-auto w-full">
            <div class="bg-white dark:bg-gray-800 p-8 rounded-xl shadow-lg text-center">
                <h2 class="text-3xl font-bold mb-2">Test Completed!</h2>
                <p class="text-gray-500 dark:text-gray-400 mb-8" id="results-test-name">Test Name</p>
                <div class="flex justify-center mb-8">
                    <div class="relative w-40 h-40">
                        <svg viewBox="0 0 36 36" class="w-full h-full stroke-current text-gray-200 dark:text-gray-700">
                            <path d="M18 2.0845 a 15.9155 15.9155 0 0 1 0 31.831 a 15.9155 15.9155 0 0 1 0 -31.831" fill="none" stroke-width="3"></path>
                            <path id="results-donut" stroke-dasharray="0, 100" d="M18 2.0845 a 15.9155 15.9155 0 0 1 0 31.831 a 15.9155 15.9155 0 0 1 0 -31.831" fill="none" stroke-width="3" stroke="currentColor" class="text-green-500"></path>
                        </svg>
                        <div class="absolute inset-0 flex items-center justify-center flex-col">
                            <span class="text-3xl font-bold" id="results-score-percent">0%</span>
                            <span class="text-sm text-gray-500">Score</span>
                        </div>
                    </div>
                </div>
                <div class="grid grid-cols-3 gap-4 mb-8 max-w-md mx-auto">
                    <div class="bg-green-50 dark:bg-green-900/20 p-3 rounded-lg border border-green-200 dark:border-green-800">
                        <div class="text-green-600 dark:text-green-400 font-bold text-2xl" id="results-correct">0</div>
                        <div class="text-xs text-green-700 dark:text-green-500 uppercase">Correct</div>
                    </div>
                    <div class="bg-red-50 dark:bg-red-900/20 p-3 rounded-lg border border-red-200 dark:border-red-800">
                        <div class="text-red-600 dark:text-red-400 font-bold text-2xl" id="results-incorrect">0</div>
                        <div class="text-xs text-red-700 dark:text-red-500 uppercase">Incorrect</div>
                    </div>
                    <div class="bg-gray-50 dark:bg-gray-700 p-3 rounded-lg border border-gray-200 dark:border-gray-600">
                        <div class="text-gray-600 dark:text-gray-300 font-bold text-2xl" id="results-skipped">0</div>
                        <div class="text-xs text-gray-500 uppercase">Skipped</div>
                    </div>
                </div>
                <div class="flex space-x-4 justify-center">
                    <button id="btn-res-dashboard" class="px-6 py-2 border border-gray-300 dark:border-gray-600 rounded-md hover:bg-gray-50 dark:hover:bg-gray-700">Dashboard</button>
                    <button id="btn-res-review" class="px-6 py-2 bg-blue-600 text-white font-bold rounded-md hover:bg-blue-700">Review Answers</button>
                </div>
            </div>
        </div>
    </div>

    <div id="review-screen" class="screen flex-row">
        <div class="flex-1 flex flex-col h-full overflow-hidden">
            <div class="bg-white dark:bg-gray-800 border-b dark:border-gray-700 px-4 py-3 flex justify-between items-center shrink-0">
                <button id="btn-rev-exit" class="text-gray-600 dark:text-gray-300 hover:text-black dark:hover:text-white flex items-center space-x-1">
                    <span>Exit Review</span>
                </button>
                <div class="font-bold" id="rev-q-num">Question 1/X</div>
            </div>
            <div class="flex-1 overflow-y-auto p-4 md:p-8">
                <div class="max-w-3xl mx-auto">
                    <div id="rev-status" class="mb-4 text-sm font-bold uppercase"></div>
                    <div id="rev-q-text" class="text-lg mb-6 font-medium"></div>
                    <div id="rev-q-media" class="mb-6 hidden"></div>
                    <div id="rev-options" class="space-y-3 mb-8"></div>
                    <div class="bg-gray-50 dark:bg-gray-900 border dark:border-gray-700 rounded-xl p-6">
                        <h4 class="font-bold text-lg mb-4 flex items-center">Explanation</h4>
                        <div id="rev-explanation" class="prose dark:prose-invert max-w-none text-sm leading-relaxed"></div>
                    </div>
                </div>
            </div>
            <div class="bg-white dark:bg-gray-800 border-t dark:border-gray-700 px-4 py-3 flex justify-between items-center shrink-0">
                <button id="btn-rev-bookmark" class="text-gray-500 hover:text-blue-500 flex items-center space-x-1">
                    <span>Bookmark</span>
                </button>
                <div class="flex space-x-2">
                    <button id="btn-rev-prev" class="px-4 py-2 border dark:border-gray-600 rounded disabled:opacity-50 hover:bg-gray-50 dark:hover:bg-gray-700">Previous</button>
                    <button id="btn-rev-next" class="px-4 py-2 bg-blue-600 text-white font-bold rounded hover:bg-blue-700">Next</button>
                </div>
            </div>
        </div>
        <div class="w-72 bg-white dark:bg-gray-800 border-l dark:border-gray-700 flex flex-col shrink-0 hidden md:flex">
            <div class="p-4 border-b dark:border-gray-700"><h3 class="font-bold mb-2">Review Navigation</h3></div>
            <div class="flex-1 overflow-y-auto p-4">
                <div id="rev-nav-grid" class="flex flex-wrap gap-2"></div>
            </div>
        </div>
    </div>
    
    <script>
        // Data injected here
        const allQuizData = __QUIZ_DATA__;

        let currentUser = null;
        let db = null;
        let currentQuizId = null;
        let currentQuizData = null;
        let currentQuestionIndex = 0;
        let timeRemaining = 0;
        let timerInterval = null;

        let quizState = { answers: {}, marked: {}, time: 0, currentQuestion: 0 };
        let userProgress = { completions: {}, bookmarks: {} };

        const screens = ['auth-screen', 'dashboard-screen', 'instructions-screen', 'quiz-screen', 'results-screen', 'review-screen'];
        function showScreen(screenId) {
            screens.forEach(s => {
                document.getElementById(s).classList.remove('active');
                document.getElementById(s).style.display = '';
            });
            document.getElementById(screenId).classList.add('active');
        }

        function toggleTheme() {
            const isDark = document.documentElement.classList.toggle('dark');
            localStorage.setItem('theme', isDark ? 'dark' : 'light');
        }
        document.getElementById('btn-theme').addEventListener('click', toggleTheme);
        if (localStorage.getItem('theme') === 'dark' || (!('theme' in localStorage) && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
            document.documentElement.classList.add('dark');
        } else {
            document.documentElement.classList.remove('dark');
        }

        async function loadUserProgress() {
            if (!currentUser) return;
            const local = localStorage.getItem(`user_${currentUser.uid}_progress`);
            if (local) userProgress = JSON.parse(local);
        }

        async function saveUserProgress() {
            if (!currentUser) return;
            localStorage.setItem(`user_${currentUser.uid}_progress`, JSON.stringify(userProgress));
        }

        document.getElementById('btn-sync').addEventListener('click', async () => {
            const btn = document.getElementById('btn-sync');
            btn.classList.add('animate-spin');
            await saveUserProgress();
            setTimeout(() => btn.classList.remove('animate-spin'), 1000);
        });

        const authForm = document.getElementById('auth-form');
        const authEmail = document.getElementById('auth-email');
        const authPassword = document.getElementById('auth-password');
        const btnAuthToggle = document.getElementById('btn-auth-toggle');
        const btnAuthSubmit = document.getElementById('btn-auth-submit');
        const btnLogout = document.getElementById('btn-logout');
        
        let usingMockAuth = true; // explicitly force true for template

        authForm.addEventListener('submit', async (e) => {
            e.preventDefault();
            if (usingMockAuth) {
                currentUser = { uid: 'mock_user_123', email: authEmail.value };
                btnLogout.classList.remove('hidden');
                document.getElementById('btn-sync').classList.remove('hidden');
                await loadUserProgress();
                renderDashboard();
                showScreen('dashboard-screen');
                return;
            }
        });

        btnLogout.addEventListener('click', () => {
            if (usingMockAuth) {
                currentUser = null;
                btnLogout.classList.add('hidden');
                document.getElementById('btn-sync').classList.add('hidden');
                showScreen('auth-screen');
            }
        });

        function renderDashboard() {
            const grid = document.getElementById('dashboard-grid');
            grid.innerHTML = '';
            allQuizData.forEach(quiz => {
                const score = userProgress.completions && userProgress.completions[quiz.id];
                const isCompleted = score !== undefined;
                const card = document.createElement('div');
                card.className = `bg-white dark:bg-gray-800 p-6 rounded-xl shadow-sm border ${isCompleted ? 'border-green-500' : 'border-gray-200 dark:border-gray-700'} flex flex-col justify-between hover:shadow-md transition`;
                let titleParts = quiz.title.split('-');
                let displayTitle = titleParts.length > 1 ? titleParts[1].replace(/_/g, ' ') : quiz.title;
                let displaySubject = titleParts.length > 1 ? titleParts[0].replace(/_/g, ' ') : 'General';
                card.innerHTML = `
                    <div>
                        <div class="text-xs font-bold text-blue-500 uppercase tracking-wider mb-2">${displaySubject}</div>
                        <h3 class="font-bold text-lg mb-2 text-gray-900 dark:text-white">${displayTitle}</h3>
                        <div class="text-sm text-gray-500 dark:text-gray-400 mb-4">${quiz.questions.length} Questions</div>
                    </div>
                    <div class="flex justify-between items-center mt-4 pt-4 border-t border-gray-100 dark:border-gray-700">
                        ${isCompleted ? `<div class="text-green-500 font-bold text-sm">Score: ${score}%</div>` : `<div class="text-gray-400 text-sm">Not started</div>`}
                        <button class="px-4 py-2 bg-blue-50 text-blue-600 dark:bg-gray-700 dark:text-blue-400 font-medium rounded hover:bg-blue-100 dark:hover:bg-gray-600 transition text-sm" onclick="startInstructions('${quiz.id}')">
                            ${isCompleted ? 'Retake' : 'Start'}
                        </button>
                    </div>
                `;
                grid.appendChild(card);
            });
        }

        window.startInstructions = function(quizId) {
            currentQuizId = quizId;
            currentQuizData = allQuizData.find(q => q.id === quizId);
            document.getElementById('inst-title').textContent = currentQuizData.title.replace(/_/g, ' ');
            document.getElementById('inst-q-count').textContent = currentQuizData.questions.length;
            showScreen('instructions-screen');
        }

        document.getElementById('btn-inst-back').addEventListener('click', () => showScreen('dashboard-screen'));

        document.getElementById('btn-inst-start').addEventListener('click', () => {
            resetQuizState();
            currentQuestionIndex = 0;
            timeRemaining = currentQuizData.questions.length * 60;
            renderQuizNavGrid();
            renderQuestion();
            startTimer();
            showScreen('quiz-screen');
        });

        function resetQuizState() { quizState = { answers: {}, marked: {}, time: 0, currentQuestion: 0 }; }

        function saveQuizState() {
            quizState.time = timeRemaining;
            quizState.currentQuestion = currentQuestionIndex;
            localStorage.setItem(`quiz_${currentQuizId}`, JSON.stringify(quizState));
        }

        function startTimer() {
            clearInterval(timerInterval);
            updateTimerUI();
            timerInterval = setInterval(() => {
                timeRemaining--;
                if (timeRemaining <= 0) { clearInterval(timerInterval); timeRemaining = 0; submitQuiz(); }
                updateTimerUI();
            }, 1000);
        }

        function updateTimerUI() {
            const mins = Math.floor(timeRemaining / 60);
            const secs = timeRemaining % 60;
            document.getElementById('quiz-timer').textContent = `${mins.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`;
        }

        function renderQuizNavGrid() {
            const grid = document.getElementById('quiz-nav-grid');
            grid.innerHTML = '';
            currentQuizData.questions.forEach((_, idx) => {
                const btn = document.createElement('button');
                btn.className = 'nav-grid-btn';
                btn.textContent = idx + 1;
                if (quizState.answers[idx]) btn.classList.add('status-answered');
                else btn.classList.add('status-unanswered');
                if (quizState.marked[idx]) btn.classList.add('status-marked');
                if (idx === currentQuestionIndex) btn.style.boxShadow = '0 0 0 2px #3b82f6';
                btn.onclick = () => { currentQuestionIndex = idx; renderQuestion(); renderQuizNavGrid(); };
                grid.appendChild(btn);
            });
        }

        function renderQuestion() {
            const q = currentQuizData.questions[currentQuestionIndex];
            document.getElementById('quiz-q-num').textContent = `Question ${currentQuestionIndex + 1} of ${currentQuizData.questions.length}`;
            document.getElementById('quiz-q-text').innerHTML = q.text;
            
            const mediaDiv = document.getElementById('quiz-q-media');
            mediaDiv.innerHTML = '';
            if (q.question_images && q.question_images.length > 0) {
                mediaDiv.classList.remove('hidden');
                q.question_images.forEach(imgUrl => {
                    const img = document.createElement('img'); img.src = imgUrl; img.className = 'max-w-full h-auto rounded-lg mb-2'; mediaDiv.appendChild(img);
                });
            } else { mediaDiv.classList.add('hidden'); }
            
            const optDiv = document.getElementById('quiz-options');
            optDiv.innerHTML = '';
            q.options.forEach(opt => {
                const btn = document.createElement('button');
                btn.className = 'option-btn flex items-start';
                if (quizState.answers[currentQuestionIndex] === opt.label) btn.classList.add('option-selected');
                btn.innerHTML = `<span class="font-bold mr-3 w-6 h-6 flex-shrink-0 bg-gray-200 dark:bg-gray-700 text-center rounded-full text-sm leading-6 flex items-center justify-center">${opt.label}</span><span>${opt.text}</span>`;
                btn.onclick = () => {
                    quizState.answers[currentQuestionIndex] = (quizState.answers[currentQuestionIndex] === opt.label) ? undefined : opt.label;
                    renderQuestion(); renderQuizNavGrid(); saveQuizState();
                };
                optDiv.appendChild(btn);
            });
            
            document.getElementById('btn-quiz-prev').disabled = currentQuestionIndex === 0;
            document.getElementById('btn-quiz-next').textContent = currentQuestionIndex === currentQuizData.questions.length - 1 ? 'Finish' : 'Next';
            
            const markBtn = document.getElementById('btn-quiz-mark');
            if (quizState.marked[currentQuestionIndex]) markBtn.classList.add('bg-yellow-50', 'dark:bg-yellow-900/30');
            else markBtn.classList.remove('bg-yellow-50', 'dark:bg-yellow-900/30');
        }

        document.getElementById('btn-quiz-prev').addEventListener('click', () => { if (currentQuestionIndex > 0) { currentQuestionIndex--; renderQuestion(); renderQuizNavGrid(); } });
        document.getElementById('btn-quiz-next').addEventListener('click', () => { if (currentQuestionIndex < currentQuizData.questions.length - 1) { currentQuestionIndex++; renderQuestion(); renderQuizNavGrid(); } else { submitQuiz(); } });
        document.getElementById('btn-quiz-mark').addEventListener('click', () => { quizState.marked[currentQuestionIndex] = !quizState.marked[currentQuestionIndex]; renderQuestion(); renderQuizNavGrid(); });
        document.getElementById('btn-quiz-submit').addEventListener('click', () => { if (confirm('Are you sure you want to submit?')) submitQuiz(); });

        function submitQuiz() {
            clearInterval(timerInterval);
            let correct = 0, incorrect = 0, skipped = 0;
            currentQuizData.questions.forEach((q, idx) => {
                const userAns = quizState.answers[idx];
                if (!userAns) skipped++;
                else if (userAns === q.options.find(o => o.correct).label) correct++;
                else incorrect++;
            });
            const scorePercent = Math.round((correct / currentQuizData.questions.length) * 100);
            if (!userProgress.completions) userProgress.completions = {};
            userProgress.completions[currentQuizId] = scorePercent;
            saveUserProgress();
            
            document.getElementById('results-test-name').textContent = currentQuizData.title.replace(/_/g, ' ');
            document.getElementById('results-score-percent').textContent = `${scorePercent}%`;
            document.getElementById('results-correct').textContent = correct;
            document.getElementById('results-incorrect').textContent = incorrect;
            document.getElementById('results-skipped').textContent = skipped;
            
            const donut = document.getElementById('results-donut');
            donut.setAttribute('stroke-dasharray', `${scorePercent}, 100`);
            if (scorePercent < 50) donut.classList.replace('text-green-500', 'text-red-500');
            else if (scorePercent < 80) donut.classList.replace('text-green-500', 'text-yellow-500');
            showScreen('results-screen');
        }

        document.getElementById('btn-res-dashboard').addEventListener('click', () => { renderDashboard(); showScreen('dashboard-screen'); });
        document.getElementById('btn-res-review').addEventListener('click', () => { currentQuestionIndex = 0; renderReviewNavGrid(); renderReviewQuestion(); showScreen('review-screen'); });

        function renderReviewNavGrid() {
            const grid = document.getElementById('rev-nav-grid');
            grid.innerHTML = '';
            currentQuizData.questions.forEach((q, idx) => {
                const btn = document.createElement('button'); btn.className = 'nav-grid-btn'; btn.textContent = idx + 1;
                const userAns = quizState.answers[idx], correctOpt = q.options.find(o => o.correct).label;
                if (!userAns) btn.classList.add('status-unanswered');
                else if (userAns === correctOpt) btn.classList.add('status-answered');
                else btn.classList.add('bg-red-500', 'text-white', 'border-red-500');
                if (idx === currentQuestionIndex) btn.style.boxShadow = '0 0 0 2px #3b82f6';
                btn.onclick = () => { currentQuestionIndex = idx; renderReviewNavGrid(); renderReviewQuestion(); };
                grid.appendChild(btn);
            });
        }

        function renderReviewQuestion() {
            const q = currentQuizData.questions[currentQuestionIndex];
            document.getElementById('rev-q-num').textContent = `Question ${currentQuestionIndex + 1} of ${currentQuizData.questions.length}`;
            const userAns = quizState.answers[currentQuestionIndex], correctOpt = q.options.find(o => o.correct).label;
            const statusEl = document.getElementById('rev-status');
            if (!userAns) { statusEl.textContent = 'UNANSWERED'; statusEl.className = 'mb-4 text-sm font-bold uppercase text-gray-500'; }
            else if (userAns === correctOpt) { statusEl.textContent = 'CORRECT'; statusEl.className = 'mb-4 text-sm font-bold uppercase text-green-500'; }
            else { statusEl.textContent = 'INCORRECT'; statusEl.className = 'mb-4 text-sm font-bold uppercase text-red-500'; }
            
            document.getElementById('rev-q-text').innerHTML = q.text;
            const optDiv = document.getElementById('rev-options');
            optDiv.innerHTML = '';
            q.options.forEach(opt => {
                const div = document.createElement('div'); div.className = 'option-btn flex items-start pointer-events-none';
                if (opt.correct) { div.classList.add('option-correct'); div.innerHTML = `<span class="font-bold mr-3 w-6 h-6 flex-shrink-0 bg-green-500 text-white text-center rounded-full text-sm leading-6 flex items-center justify-center">${opt.label}</span><span>${opt.text} <span class="ml-2 text-green-600 dark:text-green-400 text-xs font-bold">✓ Correct Answer</span></span>`; }
                else if (userAns === opt.label) { div.classList.add('option-incorrect'); div.innerHTML = `<span class="font-bold mr-3 w-6 h-6 flex-shrink-0 bg-red-500 text-white text-center rounded-full text-sm leading-6 flex items-center justify-center">${opt.label}</span><span>${opt.text} <span class="ml-2 text-red-600 dark:text-red-400 text-xs font-bold">✗ Your Answer</span></span>`; }
                else { div.innerHTML = `<span class="font-bold mr-3 w-6 h-6 flex-shrink-0 bg-gray-200 dark:bg-gray-700 text-center rounded-full text-sm leading-6 flex items-center justify-center">${opt.label}</span><span>${opt.text}</span>`; }
                optDiv.appendChild(div);
            });
            
            document.getElementById('rev-explanation').innerHTML = q.explanation || 'No explanation provided.';
            document.getElementById('btn-rev-prev').disabled = currentQuestionIndex === 0;
            document.getElementById('btn-rev-next').disabled = currentQuestionIndex === currentQuizData.questions.length - 1;
        }

        document.getElementById('btn-rev-prev').addEventListener('click', () => { if (currentQuestionIndex > 0) { currentQuestionIndex--; renderReviewNavGrid(); renderReviewQuestion(); } });
        document.getElementById('btn-rev-next').addEventListener('click', () => { if (currentQuestionIndex < currentQuizData.questions.length - 1) { currentQuestionIndex++; renderReviewNavGrid(); renderReviewQuestion(); } });
        document.getElementById('btn-rev-exit').addEventListener('click', () => showScreen('results-screen'));
    </script>
</body>
</html>
HTML_EOF

cat << 'JS_EOF' > /app/embed.js
const fs = require('fs');
let html = fs.readFileSync('/app/prepx_Anatomy.html', 'utf8');
const data = fs.readFileSync('/tmp/extracted_tests.json', 'utf8');
html = html.replace('__QUIZ_DATA__', data);
fs.writeFileSync('/app/prepx_Anatomy.html', html);
JS_EOF

node /app/embed.js
bash /home/jules/verification/verify_cuj.py
