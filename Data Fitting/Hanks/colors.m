% Define a set of 10 Monet-inspired colors
% Define a set of 10 colors inspired by Monet's "Sunrise"
waterLiliesColors = [
    0.0941, 0.1765, 0.2627;   % Deep Blue
    0.2824, 0.4627, 0.6784;   % Light Blue
    0.5922, 0.7725, 0.9451;   % Sky Blue
    0.3961, 0.6431, 0.2902;   % Green
    0.8784, 0.8392, 0.6431;   % Pale Yellow
    0.9059, 0.5843, 0.2588;   % Orange
    0.8353, 0.4549, 0.3176;   % Reddish-Brown
    0.5961, 0.4745, 0.7686;   % Purple
    0.2275, 0.2627, 0.3255;   % Dark Gray
    0.9725, 0.9725, 0.9725;   % Light Gray
];

% Create a colormap
colormap(waterLiliesColors);


surf(peaks)