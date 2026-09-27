% Proyecto SIGE - Paso 2: Simulación y Modelado
% Autor: Juan Manuel Valenciano Herrera
% Programa: Ingeniería Electrónica

% Limpieza del entorno de trabajo antes de iniciar la simulación
clear; % Borra las variables almacenadas en el workspace
clc; % Limpia la ventana de comandos para una ejecución limpia
close all; % Cierra todas las ventanas de figuras abiertas previamente

% Definición del vector de tiempo (variable independiente)
horas = 1:24; % Crea un vector fila del 1 al 24 representando el ciclo diario

% Definición de las potencias máximas de diseño (en kW)
Pmax_sol = 25;   % Límite máximo de potencia de los paneles solares
Pmax_eol = 15;   % Límite máximo de potencia de los aerogeneradores
Pmax_dem = 15;   % Límite de potencia máxima de la demanda de la comunidad

% =========================================================================
% a. Generación Solar
% =========================================================================
P_solar = zeros(1, 24); % Inicializa vector en 0 para simular la nula generación nocturna
horas_diurnas = 6:18; % Define el rango del vector correspondiente a las horas de luz
% Modela la curva solar usando la función coseno para crear una campana simétrica
P_solar(horas_diurnas) = Pmax_sol * cos((horas_diurnas - 12) * (pi / 12)); % El pico máximo se alcanza en la hora 12

% =========================================================================
% b. Generación Eólica
% =========================================================================
% Se utiliza la función rand() para generar fluctuaciones aleatorias del viento
% Se multiplica por Pmax_eol (15) para que los valores escalen de 0 a 15 kW como máximo
P_eolica = Pmax_eol * rand(1, 24); 

% =========================================================================
% c. Generación Híbrida Total
% =========================================================================
% Suma matemática vectorial (elemento a elemento) de ambas fuentes renovables
P_total = P_solar + P_eolica; 

% =========================================================================
% d. Demanda de la Comunidad
% =========================================================================
demanda = zeros(1, 24); % Inicializa el vector base de consumo poblacional

% Consumo base (madrugada y noche): Oscilación controlada entre 2 y 4 kW usando rand()
demanda(1:5) = 2 + (4 - 2) * rand(1, 5); % Rango nocturno inicial (Horas 1 a 5)
demanda(22:24) = 2 + (4 - 2) * rand(1, 3); % Rango nocturno final (Horas 22 a 24)

% Consumo diurno (escuela y bombeo): Oscilación controlada entre 6 y 10 kW
demanda(6:17) = 6 + (10 - 6) * rand(1, 12); % Asignación aleatoria en bloque diurno

% Pico máximo de demanda: Se asignan valores específicos para alcanzar Pmax_dem
demanda(18:21) = [11, 13, Pmax_dem, 12]; % El pico exacto (15 kW) se da en la hora 20

% =========================================================================
% e. Visualización Gráfica
% =========================================================================
figure('Color', 'white'); % Crea el entorno gráfico asegurando un fondo blanco
% Comando plot para graficar P_total vs tiempo. Se configura color naranja y grosor de línea 2
plot(horas, P_total, 'LineWidth', 2, 'Color', [0.8500 0.3250 0.0980]); 
hold on; % Congela el gráfico actual para permitir la superposición de la siguiente curva
% Comando plot para graficar la demanda vs tiempo en color azul
plot(horas, demanda, 'LineWidth', 2, 'Color', [0 0.4470 0.7410]); 

% Configuración de etiquetas y diseño estético del gráfico
title('Simulación SIGE', 'FontSize', 12, 'FontWeight', 'bold'); % Título del gráfico
xlabel('Tiempo en horas(h)'); % Etiqueta descriptiva del eje X
ylabel('Potencia en Kilovatios(kW)'); % Etiqueta descriptiva del eje Y
grid on; % Activa la cuadrícula de fondo para facilitar la lectura de datos
legend('Generación Total', 'Demanda del pueblo', 'Location', 'best'); % Identificador visual de curvas
xlim([1 24]); % Limita estrictamente la visualización del eje X a 24 horas
xticks(1:2:24); % Configura las marcas del eje X para que aparezcan cada 2 horas