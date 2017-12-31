function [whistle_count,maybe_downward_glitch,maybe_whistle,consecutive_maybe_whistle_events] = count_whistles_from_label(whistle_count,predicted_label,maybe_whistle,maybe_downward_glitch,consecutive_maybe_whistle_events)

if predicted_label ~= 0 && maybe_whistle == 0
    maybe_downward_glitch = 0;
    maybe_whistle = 1;
    consecutive_maybe_whistle_events = consecutive_maybe_whistle_events + 1;
elseif predicted_label ~= 0 && maybe_whistle == 1 && consecutive_maybe_whistle_events < 3
    maybe_downward_glitch = 0;
    consecutive_maybe_whistle_events = consecutive_maybe_whistle_events + 1;
elseif predicted_label ~= 0  && maybe_whistle == 1 && consecutive_maybe_whistle_events == 3
    maybe_downward_glitch = 0;
    whistle_count = whistle_count + 1;
    consecutive_maybe_whistle_events = nan;
elseif predicted_label == 0 && maybe_whistle == 1 && maybe_downward_glitch < 2
    maybe_downward_glitch = maybe_downward_glitch + 1;
elseif predicted_label == 0 && maybe_whistle == 1 && maybe_downward_glitch == 2
    maybe_downward_glitch = 0;
    maybe_whistle = 0;
    consecutive_maybe_whistle_events = 0;
end