%% for reaction time by histogram
%function [speed_LL, accuracy_LL] = QMLE(data)
function speed_LL = QMLE(data)
% QMLE, quantile maximum likelihood estimation
% reference: Heathcote & Australia, and Mewhort, 2002.

% speed
speed_h = figure;
speed = data.speed;
speed_coh = data.speed_coh;
speed_qmat = data.speed_qmat;

for vi = 1: length(speed_coh)
    correct_RT = speed.rt(speed.coh == speed_coh(vi) & speed.cor == 1) / 1000;
    wrong_RT = speed.rt(speed.coh == speed_coh(vi) & speed.cor == 0) / 1000;
    speed_observation_num(vi) = length(speed.rt(speed.coh == speed_coh(vi)));

    if ~any(isnan(speed_qmat(:, 1, vi)))
        temp = histogram(correct_RT, [0; speed_qmat(:, 1, vi); Inf]);
        speed_estimate_qnum(:, 1, vi) = temp.Values;
    else
        speed_estimate_qnum(:, 1, vi) = NaN(length(speed_qmat(:, 1, vi))+1, 1);
    end

    if ~any(isnan(speed_qmat(:, 2, vi)))
        temp = histogram(wrong_RT, [0; speed_qmat(:, 2, vi); Inf]);
        speed_estimate_qnum(:, 2, vi) = temp.Values;
    else
        speed_estimate_qnum(:, 2, vi) = NaN(length(speed_qmat(:, 2, vi))+1, 1);
    end

    f(:, :, vi) = log(speed_estimate_qnum(:, :, vi) / speed_observation_num(vi));
    f(f(:, 1, vi)==-Inf, 1, vi) = log(.1/speed_observation_num(vi));
    f(f(:, 2, vi)==-Inf, 2, vi) = log(.1/speed_observation_num(vi));
end

speed_LL = sum(speed_observation_num(:) .* f(:), 'omitnan');
close(speed_h);


% accuracy
accuracy_h = figure;
accuracy = data.accuracy;
accuracy_coh = data.accuracy_coh;
accuracy_qmat = data.accuracy_qmat;

for vi = 1: length(accuracy_coh)
    correct_RT = accuracy.rt(accuracy.coh == accuracy_coh(vi) & accuracy.cor == 1) / 1000;
    wrong_RT = accuracy.rt(accuracy.coh == accuracy_coh(vi) & accuracy.cor == 0) / 1000;
    accuracy_observation_num(vi) = length(accuracy.rt(accuracy.coh == accuracy_coh(vi)));

    if ~any(isnan(accuracy_qmat(:, 1, vi)))
        temp = histogram(correct_RT, [0; accuracy_qmat(:, 1, vi); Inf]);
        accuracy_estimate_qnum(:, 1, vi) = temp.Values;
    else
        accuracy_estimate_qnum(:, 1, vi) = NaN(length(accuracy_qmat(:, 1, vi))+1, 1);
    end

    if ~any(isnan(accuracy_qmat(:, 2, vi)))
        temp = histogram(wrong_RT, [0; accuracy_qmat(:, 2, vi); Inf]);
        accuracy_estimate_qnum(:, 2, vi) = temp.Values;
    else
        accuracy_estimate_qnum(:, 2, vi) = NaN(length(accuracy_qmat(:, 2, vi))+1, 1);
    end

    f(:, :, vi) = log(accuracy_estimate_qnum(:, :, vi) / accuracy_observation_num(vi));
    f(f(:, 1, vi)==-Inf, 1, vi) = log(.1/accuracy_observation_num(vi));
    f(f(:, 2, vi)==-Inf, 2, vi) = log(.1/accuracy_observation_num(vi));
end

accuracy_LL = sum(accuracy_observation_num .* f, 'omitnan');
close(accuracy_h)