function KursWorkGraphBuilder()

%% Графопостроитель для курсовой работы по <Разработка и эксплуатация радиотелеметрических систем>
t1 = 2 / 1000; % t1 из задания

tPulse = 2 * t1; % Длительность импульса (тау импульса)
accuracyOfGraphs = 300; % Точность графиков (чем больше число, тем дольше построение и плавнее графики)

%% 1 пункт
% Впишите свои формулы в
% $s(t)$ - "signalGeneralForm" - Формула сигнала
% $s'(t)$ - "firstDerivative" - Формула первой производной сигнала
% $s''(t)$ - "secondDerivative" - Формула второй производной сигнала
% $S(\omega)$ - "spectralDensityOfSignal" - Формула спектра сигнала

% Сигнал и производные
isPlotFirstDerivative = true; % Строить графки первой производной ?
isPlotSecondDerivative = true; % Строить графки второй производной ?
numberCharts = 1 + isPlotFirstDerivative + isPlotSecondDerivative;
figure
x = (-tPulse:tPulse / accuracyOfGraphs:tPulse) * 1000;
y = zeros(numberCharts, length(x));
subplot(numberCharts, 1, 1)
for i = 1:length(x)
    t = x(i) / 1000;
    y(1, i) = signalGeneralForm(t, tPulse);

    if (isPlotFirstDerivative)
        y(1 + isPlotFirstDerivative, i) = firstDerivative(t, tPulse); % s'(t) - формула первой производной
    end

    if (isPlotSecondDerivative)
        y(1 + isPlotFirstDerivative + isPlotSecondDerivative, i) = secondDerivative(t, tPulse); % s''(t) - формула второй производной
    end
end

if (numberCharts >= 1)
    plot(x, y(1, :))
    grid;
    xlabel('t, мс');
    ylabel('s(t), В');
    title('Сигнал');
    xlim([x(1), x(end)]);
end

if (numberCharts >= 2)
    subplot(numberCharts, 1, 1 + isPlotFirstDerivative);
    plot(x, y(1 + isPlotFirstDerivative, :))
    grid;
    xlabel('t, мс');
    ylabel("s'(t), В/мс");
    title('Первая производная сигнала');
    xlim([x(1), x(end)]);
end

if (numberCharts >= 3)
    subplot(numberCharts, 1, 1 + isPlotFirstDerivative + isPlotSecondDerivative);
    plot(x, y(1 + isPlotFirstDerivative + isPlotSecondDerivative, :))
    % Начало блока кода для добавления дельта функций в конкретных точках
    line([2, 2], [0, 2]);
    line(2, 2, 'marker', 'o');
    line([-2, -2], [0, 2]);
    line(-2, 2, 'marker', 'o');
    % Конец блока кода для добавления дельта функций
    grid;
    xlabel('t, мс');
    ylabel("s''(t), В/мс");
    title('Вторая производная сигнала');
    xlim([x(1), x(end)]);
end

clear x y
clear numberCharts isPlotFirstDerivative isPlotSecondDerivative t i
% Спектры
distToLeftAndRightSpectrBoundaries = abs(15);
figure
x = -distToLeftAndRightSpectrBoundaries:distToLeftAndRightSpectrBoundaries * 2 / accuracyOfGraphs:distToLeftAndRightSpectrBoundaries;
y = zeros(2, length(x));
onePercentOfMax = amplitudeSpectrumOfSignal(0, tPulse) * 0.1; % 1% от максимума амплитудного спектра
for i = 1:length(x)
    w = x(i) * 1000;
    y(1, i) = 1000 * amplitudeSpectrumOfSignal(w, tPulse); % Формула амплитудного спектра
    y(2, i) = 1000 * onePercentOfMax; % Линия 1% от максимума
    y(3, i) = spectralPhaseOfSignal(w, tPulse); % Формула фазового спектра
end

subplot(2, 1, 1);
plot(x, y(1:2, :))
grid;
xlabel('\omega, рад/мс');
ylabel('|S(\omega)|, В/кГц');
title('Амплитудный спектр');

subplot(2, 1, 2);
plot(x, y(3, :))
grid;
xlabel('\omega, рад/мс');
ylabel('\phi(\omega), рад');
title('Фазовый спектр');

dw = calcDw(tPulse); % Ширина спектра вычисляется по графику из 1 пункта

disp('Автоматическое вычисление ширины спектра может работать неверно особенно для кодированного сигнала.')
disp(['Автоматически вычисленная ширина спектра: ', num2str(dw), ' рад/мс'])

isSpectrumWidthWasDeterminedIncorrectly = false; % Заменит автоматически определенную ширину спектра?
if isSpectrumWidthWasDeterminedIncorrectly
    dw = 8; % Ширина спектра
end

clear x y
clear onePercentOfMax w t i isSpectrumWidthWasDeterminedIncorrectly distToLeftAndRightSpectrBoundaries

%% 2 пункт
% Дополните формулу $s(t)$ - "signalGeneralForm" - Формула для получения периодического сигнала
% Cигнал

Q = 5; % Скважность
T = Q * tPulse;
NumberPulses = 5;
figure
x = (-T * NumberPulses / 2:T * NumberPulses / accuracyOfGraphs:T * NumberPulses / 2) * 10^3; % Подсчет сколько нужно места для отображения всех имульсов
y = zeros(1, length(x));
for i = 1:length(x)
    t = x(i) / 1000;
    s = 0;
    for n = -floor(NumberPulses / 2):floor(NumberPulses / 2)
        s = s + signalGeneralForm(t, tPulse, T, n);
    end
    y(i) = s;
end
plot(x, y, 'LineWidth', 1)
xlim([x(1), x(end)])
grid
xlabel('t, мс');
ylabel('s_п(t), В');
title('Временная диаграмма периодического сигнала');

clear x y
clear onePercentOfMax s i NumberPulses t n

%% Спектры
distToRightSpectrBoundarie = abs(10); % Расстояние до правой границы спектра
figure
w1 = 2 * pi / T; % Частота первой гармоники
x = 0:w1 / 1000:distToRightSpectrBoundarie;
y = zeros(1, length(x));
subplot(2, 1, 1);
xlim([0, distToRightSpectrBoundarie])
for i = 1:length(x)
    w = x(i) * 1000;
    s = 2 / T * amplitudeSpectrumOfSignal(w, tPulse);
    if w == 0
        s = s / 2;
    end
    y(i) = s;
end
stem(x, y)
hold on;
plot(x, y, '--', 'Color', [1, 0, 0])
grid;
xlabel('\omega, рад/мс');
ylabel('\{A_n\}, В');
title('Амплитудный спектр');

subplot(2, 1, 2)
xlim([0, distToRightSpectrBoundarie])
y = zeros(1, length(x));
for i = 1:length(x)
    w = x(i);
    y(i) = spectralPhaseOfSignal(w * 1000, tPulse);
end
stem(x, y)
hold on;
plot(x, y, '--', 'Color', [1, 0, 0])
grid;
xlabel('\omega, рад/мс');
ylabel('\{\phi_n\}, рад');
title('Фазовый спектр');
clear x y
clear s w i distToRightSpectrBoundarie
% Апроксимация
figure
nAccuracys = [10, 25, 50]; % Для каких n требуется построить графики
x = (-T / 2:T / accuracyOfGraphs:T / 2) * 10^3;
y = zeros(length(nAccuracys), length(x));
for i = 1:length(x)
    t = x(i) / 1000;
    s(1:length(nAccuracys)) = 2 / 15;
    for n = 1:max(nAccuracys)
        w = w1 * n;
        sn = 2 / T * amplitudeSpectrumOfSignal(w, tPulse) * cos(w * t + spectralPhaseOfSignal(w, tPulse));
        for j = 1:length(nAccuracys)
            if (nAccuracys(j) >= n)
                s(j) = s(j) + sn;
            end
        end
    end
    y(:, i) = s;
end

for i = 1:length(nAccuracys)
    subplot(length(nAccuracys), 1, i);
    plot(x, y(i, :))
    xlim([x(1), x(end)]);
    grid;
    xlabel('t, мс');
    ylabel('s_п(t), В');
    title(strcat('n=', sprintf('%d', nAccuracys(i))));
end
clear x y
clear i j n t w s sn nAccuracys

%% 3 пункт
RadioPulseCarrierFrequency = dw * 100;
disp(['Несущая частота радиоимпульса: ', num2str(RadioPulseCarrierFrequency), ' рад/мс'])

% Радио сигнал
figure
x = (-T / 2:T / (accuracyOfGraphs * 4):T / 2) * 10^3;
y = zeros(2, length(x));
for i = 1:length(x)
    t = x(i) / 1000;
    signal = signalGeneralForm(t, tPulse);
    y(1, i) = signal * cos(RadioPulseCarrierFrequency * 1000 * t);
    y(2, i) = signal;
end
plot(x, y(1, :))
hold on;
plot(x, y(2, :), '--', 'Color', [1, 0, 0])
plot(x, -y(2, :), '--', 'Color', [1, 0, 0])
grid;
xlim([x(1), x(end)]);
xlabel('t, мс');
ylabel('u(t), В');
title('Временная диаграмма непериодического радиосигнала');
clear x y
clear i t signal
% Спектры
distToLeftAndRightSpectrBoundaries = abs(10); % Расстояние до левой и правой границы спектров
% Положительные частоты
figure
x = ((RadioPulseCarrierFrequency - distToLeftAndRightSpectrBoundaries):distToLeftAndRightSpectrBoundaries * 2 / accuracyOfGraphs:(RadioPulseCarrierFrequency + distToLeftAndRightSpectrBoundaries));
y = zeros(2, length(x));
subplot(2, 1, 1);
for i = 1:length(x)
    w = x(i);
    y(1, i) = 1 / 2 * amplitudeSpectrumOfSignal((w - RadioPulseCarrierFrequency) * 1000, tPulse) * 1000;
    y(2, i) = spectralPhaseOfSignal((w - RadioPulseCarrierFrequency) * 1000, tPulse);
end
plot(x, y(1, :));
grid;
xlabel('\omega, рад/мс');
xlim([x(1), x(end)]);
ylabel('|U(\omega)|, В/кГц');
title('Амплитудный спектр');
subplot(2, 1, 2);
plot(x, y(2, :));
grid;
xlim([x(1), x(end)]);
xlabel('\omega, рад/мс');
ylabel('\phi_U (\omega), рад');
title('Фазовый спектр');
clear x y
clear i t w
% Отрицательные частоты
figure
x = ((-RadioPulseCarrierFrequency - distToLeftAndRightSpectrBoundaries):distToLeftAndRightSpectrBoundaries * 2 / accuracyOfGraphs:(-RadioPulseCarrierFrequency + distToLeftAndRightSpectrBoundaries));
y = zeros(2, length(x));
subplot(2, 1, 1);
for i = 1:length(x)
    w = x(i);
    y(1, i) = 1 / 2 * amplitudeSpectrumOfSignal((w + RadioPulseCarrierFrequency) * 1000, tPulse) * 1000;
    y(2, i) = spectralPhaseOfSignal((w + RadioPulseCarrierFrequency) * 1000, tPulse);
end
plot(x, y(1, :))
grid;
xlim([x(1), x(end)]);
xlabel('\omega, рад/мс');
ylabel('|U(\omega)|, В/кГц');
title('Амплитудный спектр');
subplot(2, 1, 2);
plot(x, y(2, :))
grid;
xlim([x(1), x(end)]);
xlabel('\omega, рад/мс');
ylabel('\phi_U (\omega), рад');
title('Фазовый спектр');
clear x y
clear i t w distToLeftAndRightSpectrBoundaries

%% 4 пункт
% Сигнал
figure
NumberPulses = 5;
x = (-T * NumberPulses / 2:T / (accuracyOfGraphs * 4):T * NumberPulses / 2) * 10^3;
y = zeros(2, length(x));
for i = 1:length(x)
    t = x(i) / 1000;
    s = zeros(1, 2);
    for n = -floor(NumberPulses / 2):floor(NumberPulses / 2)
        signal = signalGeneralForm(t, tPulse, T, n);
        s(1) = s(1) + signal * cos(RadioPulseCarrierFrequency * 1000 * t);
        s(2) = s(2) + signal;
    end
    y(:, i) = s;
end

plot(x, y(1, :))
hold on;
grid;
plot(x, y(2, :), '--', 'Color', [1, 0, 0])
plot(x, -y(2, :), '--', 'Color', [1, 0, 0])
xlim([x(1), x(end)]);
xlabel('t, мс');
ylabel('u_п(t), В');
title('Временная диаграмма периодического радиосигнала');
clear x y
clear i n t s signal
% Спектры
distToLeftAndRightSpectrBoundaries = abs(10); % Расстояние до левой и правой границы спектров
figure
x = [fliplr(-1 * (0:w1 / 1000:distToLeftAndRightSpectrBoundaries)) + RadioPulseCarrierFrequency, (0:w1 / 1000:distToLeftAndRightSpectrBoundaries) + RadioPulseCarrierFrequency];
y = zeros(2, length(x));
subplot(2, 1, 1)
for i = 1:length(x)
    w = (x(i) - RadioPulseCarrierFrequency) * 1000;
    y(1, i) = 1 / T * amplitudeSpectrumOfSignal(w, tPulse);
    y(2, i) = spectralPhaseOfSignal(w, tPulse);
end
hold on
stem(x, y(1, :));
plot(x, y(1, :), '--', 'Color', [1, 0, 0]);
xlim([x(1), x(end)]);
grid;
xlabel('\omega, рад/мс');
ylabel('\{V_n\}_{n=\infty}^{+\infty}, В', 'FontSize', 10);
title('Амплитудный спектр');

subplot(2, 1, 2);
hold on;
stem(x, y(2, :))
plot(x, y(2, :), '--', 'Color', [1, 0, 0])
xlim([x(1), x(end)]);
grid;
xlabel('\omega, рад/мс');
ylabel('\{\phi_n\}_{n=\infty}^{+\infty}', 'FontSize', 10);
title('Фазовый спектр');
clear x y
clear i signal w

%% 5 пункт
% Впишите свои формулы в $R(t)$ - "rFormula"
% Сигнал + смещенный сигнал
figure
x = (-tPulse:tPulse / accuracyOfGraphs:tPulse * 1.5) * 10^3;
y = zeros(2, length(x));
for i = 1:length(x)
    t = x(i) / 1000;
    y(1, i) = signalGeneralForm(t, tPulse);
    y(2, i) = signalGeneralForm(t - tPulse / 2, tPulse);
end
plot(x, y(1, :))
grid
hold on
plot(x, y(2, :), '--', 'Color', [1, 0, 0])
xlabel('\tau, мс');
ylabel('В');
set(gca, 'XTick', [])
legend({'S_1(t)', 'S_2(t-\tau)'}, 'Location', 'northwest')
title('К расчету АКФ');
% АКФ сигнала
figure
x = (-tPulse:2 * tPulse / accuracyOfGraphs:tPulse) * 1000;
y = zeros(1, length(x));
for i = 1:length(x)
    t = x(i) / 1000;
    y(i) = 1000 * rFormula(t, tPulse);
end
plot(x, y)
grid;
xlabel('\tau, мс');
ylabel('R(\tau), мДж');
title('АКФ заданного сигнала');
xlim([x(1), x(end)]);
% АКФ радиоимпульса
figure
x = (-tPulse:2 * tPulse / accuracyOfGraphs:tPulse) * 1000;
y = zeros(2, length(x));
for i = 1:length(x)
    t = x(i) / 1000;
    y(1, i) = 1 / 2 * 1000 * rFormula(t, tPulse) * cos(RadioPulseCarrierFrequency * 1000 * t);
    y(2, i) = 1 / 2 * 1000 * rFormula(t, tPulse);
end
hold on;
plot(x, y(1, :))
grid;
plot(x, y(2, :), '--', 'Color', [1, 0, 0])
plot(x, -y(2, :), '--', 'Color', [1, 0, 0])
xlabel('\tau, мс');
ylabel('R_u(\tau), мДж');
title('АКФ радиоимпульса');
xlim([x(1), x(end)]);

%% 6 пункт

tau = 10 * t1; % тау в цепи
H0 = 0.5;
Hinf = 0;
distToLeftAndRightBoundaries = 0.5;
end

%% Формулы
% Формула для вычисления сигнала
function r = signalGeneralForm(t, tPulse, varargin)
if nargin == 2
    T = 0;
    n = 0;
elseif nargin == 4
    T = varargin{1};
    n = varargin{2};
else
    error('SignalGeneralForm accepts up to 4 input arguments!')
end
if n == 0
    %Формула требуется для подсчета всех пунктов
    r = (1 - (2 * t / tPulse)^2) * rect(t / tPulse); % заданный сигнал математически в общем виде s(t)
else
    %Формула требуется для подсчета пунктов 2 и 4
    r = (1 - (2 * (t - n * T) / tPulse)^2) * rect((t - n * T) / tPulse); % заданный периодический сигнал математически в общем виде s(t)
end
end

% Формула первой производной заданного сигнала
function r = firstDerivative(t, tPulse)
%Формула требуется для подсчета  пунктов  1
r = -8 * t / tPulse^2 * rect(t / tPulse) * 10^-3;
end

% Формула второй производной заданного сигнала
function r = secondDerivative(t, tPulse)
%Формула требуется для подсчета  пунктов  1
r = (-8 / tPulse^2 * rect(t / tPulse)) * 10^-6;
end

% Формула спектральной плотности заданного сигнала
function r = spectralDensityOfSignal(w, tPulse)
%Формула требуется для подсчета  пунктов  1, 2, 3, 4
if w == 0
    r = 2 * tPulse / 3;
else
    r = 8 / (w^2 * tPulse) * (sinc(w * tPulse / 2) - cos(w * tPulse / 2));
end
end

% Формула амплитудного спектра заданного сигнала
function r = amplitudeSpectrumOfSignal(w, tPulse)
%Формула требуется для подсчета  пунктов  1, 2, 3, 4
r = abs(spectralDensityOfSignal(w, tPulse)); % Данная формула уневерсальная для множества варинтов, важможно её не придётся менять
end

% Формула фазового спектра заданного сигнала
function r = spectralPhaseOfSignal(w, tPulse)
%Формула требуется для подсчета  пунктов  1, 2, 3, 4
r = angle(spectralDensityOfSignal(w, tPulse)); % Данная формула уневерсальная для множества варинтов, важможно её не придётся менять
if w < 0
    r = r * -1;
end
end

% Формула АКФ
function r = rFormula(t, tPulse)
%Формула требуется для подсчета пункта 5
r = 8 * tPulse / 15 * (1 - 5 * (t / tPulse)^2 + 5 * (abs(t) / tPulse)^3 - (abs(t) / tPulse)^5) * rect(t / (2 * tPulse));
end

%% Системные функции (не влезай убьет!)
function r = calcDw(tPulse)
previousValue = amplitudeSpectrumOfSignal(0, tPulse);
onePercentOfMax = previousValue * 0.1; % 1% от максимума амплитудного спектра
isConsiderPetal = true;
isIncreasing = false;
for i = (1:2:1000) / 100
    w = i * 1000;
    value = amplitudeSpectrumOfSignal(w, tPulse); % Формула амплитудного спектра
    if isIncreasing ~= (sign(value - previousValue) ~= -1)
        if isIncreasing == false
            if isConsiderPetal
                r = i * 2;
                isConsiderPetal = false;
            else
                return
            end
        end
        isIncreasing = (sign(value - previousValue) ~= -1);
    end
    if value >= onePercentOfMax
        isConsiderPetal = true;
    end
    previousValue = value;
end
r = i;
end

% Мат функции
function r = sinc(x)
if x == 0
    r = 1;
else
    r = sin(x) / x;
end
end

function r = rect(x)
if abs(x) > 0.5
    r = 0;
elseif abs(x) == 0.5
    r = 0.5;
elseif abs(x) < 0.5
    r = 1;
end
end
