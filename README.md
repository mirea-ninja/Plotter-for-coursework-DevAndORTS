# Графопостроитель для курсовой работы по <Разработка и эксплуатация радиотелеметрических систем>

---
[![License: GPL v3](https://img.shields.io/badge/License-GPL_v3-blue.svg)](./LICENSE)

## Краткое описание

---

Скрипт предназначен для максимально простого построения графиков для курсовой работы, при минимальных знаниях
программирования и минимальных временных затратах. Работает в программах
[Octave](https://www.gnu.org/software/octave/)
и [Matlab](https://www.mathworks.com/products/matlab.html)

## Использование

---

### Пункт 1

Присвойте переменной `t1` значение из задания.

```matlab
t1 = 2 / 1000; % t1 из задания
```

Измените расчетную формулу импульса переменной `tPulese`.

```matlab
tPulse = 2 * t1; % Длительность импульса (тау импульса)
```

Добавьте формулу расчета вашего сигнала в функцию `signalGeneralForm` для n=0.

```matlab
% Формула для вычисления сигнала
function r = signalGeneralForm(t, tPulse, varargin)
%...
if n == 0
    %Формула требуется для подсчета всех пунктов
   r = (1 - (2 * t / tPulse)^2) * rect(t / tPulse); % заданный сигнал математически в общем виде s(t)
else
%...
end
end
```

Если требуется построить график первой производной сигнала, то добавьте её в функцию `firstDerivative` и присвойте
переменной `isPlotFirstDerivative` значение `true`.

Если не требуется строить график первой производной сигнала, то присвойте переменной `isPlotFirstDerivative`
значение `false`.

```matlab
% Формула первой производной заданного сигнала
function r = firstDerivative(t, tPulse)
%Формула требуется для подсчета  пунктов  1
r = -8 * t / tPulse^2 * rect(t / tPulse) * 10^-3;
end
```

Если требуется построить график второй производной сигнала, то добавьте её в функцию `secondDerivative`
и присвойте переменной `isPlotSecondDerivative` значение `true`.

Если не требуется строить график первой производной сигнала, то присвойте переменной `isPlotSecondDerivative`
значение `false`.

```matlab
% Формула второй производной заданного сигнала
function r = secondDerivative(t, tPulse)
%Формула требуется для подсчета  пунктов  1
r = (-8 / tPulse^2 * rect(t / tPulse)) * 10^-6;
end
```

Добавьте формулу расчета спектра вашего сигнала в функцию `spectralDensityOfSignal`.

```matlab
% Формула спектральной плотности заданного сигнала
function r = spectralDensityOfSignal(w, tPulse)
%Формула требуется для подсчета  пунктов  1, 2, 3, 4
if w == 0
    r = 2 * tPulse / 3;
else
    r = 8 / (w^2 * tPulse) * (sinc(w * tPulse / 2) - cos(w * tPulse / 2));
end
end
```

Первый пункт готов.

После запуска скрипта в консоль выведется сообщение:
> Автоматическое вычисление ширины спектра может работать неверно особенно для кодированного сигнала.  
> Автоматически вычисленная ширина спектра: x.xx рад/мс

Если автоматически вычисленное значение ширины спектра не верно, то его можно исправить. Присвойте значение `true`
переменной `isSpectrumWidthWasDeterminedIncorrectly`, а `dw` внутри `if` правильное значение.

Если автоматически вычисленное значение ширины спектра верно, то присвойте значение `false`
переменной `isSpectrumWidthWasDeterminedIncorrectly`,

```matlab
isSpectrumWidthWasDeterminedIncorrectly = true; % Заменит автоматически определенную ширину спектра?
if isSpectrumWidthWasDeterminedIncorrectly
    dw = 8; % Ширина спектра
end
```

### Пункт 2, 3 и 4

Добавьте формулу расчета вашего **периодического** сигнала в функцию `signalGeneralForm` для различных n.

```matlab
% Формула для вычисления сигнала
function r = signalGeneralForm(t, tPulse, varargin)
%...
if n == 0
%...
else
    %Формула требуется для подсчета пунктов 2 и 4
    r = (1 - (2 * (t - n * T) / tPulse)^2) * rect((t - n * T) / tPulse); % заданный периодический сигнал математически в общем виде s(t)
end
end
```

Второй, третий и четвертый пункт готовы.

### Пункт 5

Добавьте формулу АКФ в функцию `rFormula`

```matlab
% Формула АКФ
function r = rFormula(t, tPulse)
%Формула требуется для подсчета пункта 5
r = 8 * tPulse / 15 * (1 - 5 * (t / tPulse)^2 + 5 * (abs(t) / tPulse)^3 - (abs(t) / tPulse)^5) * rect(t / (2 * tPulse));
end
```

Пятый пункт готов.

### Пункт 6

Измените расчетную формулу импульса переменной `tau` по данным из задания.

```matlab
tau = 10 * t1; % тау в цепи
```

Присвойте переменной `H0` значение рассчитанное в курсовой работе.

```matlab
H0 = 0.5;
```

Присвойте переменной `Hinf` значение рассчитанное в курсовой работе.

```matlab
Hinf = 0;
```

Присвойте переменной `distToLeftAndRightBoundaries` формулу из курсовой или собственное значение для границ графика.

```matlab
distToLeftAndRightBoundaries = 0.5;
```

Присвойте переменной `distToRightBoundary` формулу из курсовой или собственное значение для правой границы графика.

```matlab
distToRightBoundary = 5 * tau * 1000;
```

Присвойте переменной `distToRightBoundary` формулу из курсовой или собственное значение для правой границы графика.

```matlab
distToRightBoundary = (tPulse + 5 * tau) * 1000;
```

Измените формулу после `y(1, i) =` для вашего Uвх.

```matlab
y(1, i) = -8 * s2Formula(t) / tPulse^2 + 4 * s1Formula(t) / tPulse + 8 * s2Formula(t - tPulse) / tPulse^2 + 4 * s1Formula(t - tPulse) / tPulse;
```

Измените формулу после `y(2, i) =` для вашего Uвых.

```matlab
y(2, i) = -8 * g2Formula(t, tau) / tPulse^2 + 4 * g1Formula(t, tau, Hinf, H0) / tPulse + 8 * g2Formula(t - tPulse, tau) / tPulse^2 + 4 * g1Formula(t - tPulse, tau, Hinf, H0) / tPulse;
```

## Часто задаваемые вопросы

---

* #### При открытии файла в **Octave** часть текста отображается кракозябрами, что делать?

Правка -> Параметры -> Редактор -> Кодировка по умолчанию -> UTF-8

Edit -> Preferences -> Editor -> Text encoding used for loading and saving -> UTF-8