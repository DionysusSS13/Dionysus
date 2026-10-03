// This is just a wrapper for preference type IDs to their components.
// Intentionally dumber than TGUI prefs.
// Keep it simple, stupid.

// If you change this, make sure to update the preferences define file too.

import { useBackend } from '../../backend';
import { LabeledList } from '../../components';
import { PreferenceData, PreferencesMenuData } from './data';
import {
  CheckboxInput,
  CheckboxInputInverse,
  createDropdownInput,
  FeatureColorInput,
  FeatureDropdownInput,
  FeatureDropdownSwitcherInput,
  FeatureIconnedDropdownInput,
  FeatureNumberInput,
  FeatureShortTextInput,
  FeatureTextInput,
  FeatureTriColorInput,
  FeatureValue,
  FeatureValueInput,
} from './preferences/features/base';
import { FpsInput as FeatureFpsInput } from './preferences/features/game_preferences/FpsInput';
import { UIStyleInput as FeatureUIStyleInput } from './preferences/features/game_preferences/UIStyleInput';
import { ServerPreferencesFetcher } from './ServerPreferencesFetcher';

export const FEATURE_ID_TO_COMPONENT: Record<
  string,
  FeatureValue<unknown, unknown, unknown>
> = {
  color: FeatureColorInput,
  checkbox: CheckboxInput,
  checkbox_inverse: CheckboxInputInverse,
  dropdown: FeatureDropdownInput,
  dropdown_switcher: FeatureDropdownSwitcherInput,
  iconned_dropdown: FeatureIconnedDropdownInput,
  number: FeatureNumberInput,
  long_text: FeatureTextInput,
  short_text: FeatureShortTextInput,
  tri_color: FeatureTriColorInput,
  fps: FeatureFpsInput,
  ui_style: FeatureUIStyleInput,
  scaling_method: createDropdownInput({
    blur: 'Bilinear',
    distort: 'Nearest Neighbor',
    normal: 'Point Sampling',
  }),
};

export const PreferenceDataComponent = (props: {
  prefCategory: string;
  prefId: string;
}) => {
  return (
    <ServerPreferencesFetcher
      render={(serverData) => {
        if (!serverData) {
          return;
        }
        const { act, data } = useBackend<PreferencesMenuData>();
        const prefData = serverData[props.prefId] as PreferenceData;
        return FEATURE_ID_TO_COMPONENT[prefData.feature] ? (
          <FeatureValueInput
            act={(action, data) => {
              act(action, data);
            }}
            feature={FEATURE_ID_TO_COMPONENT[prefData.feature]}
            featureId={props.prefId}
            shrink
            value={data.character_preferences[props.prefCategory][props.prefId]}
          />
        ) : (
          `INVALID FEATURE ${prefData.feature} FOR ${props.prefId}`
        );
      }}
    />
  );
};

export const AllFeaturesInCategory = (props: { category: string }) => {
  const { act, data } = useBackend<PreferencesMenuData>();

  return (
    <ServerPreferencesFetcher
      render={(serverData) => {
        if (!serverData) {
          return;
        }

        return (
          <LabeledList>
            {Object.keys(data.character_preferences[props.category]).map(
              (k) => {
                const prefData = serverData[k] as PreferenceData;
                if (prefData.feature === 'none') {
                  return;
                }
                return (
                  <LabeledList.Item
                    key={k}
                    label={prefData.name!!}
                    verticalAlign="top"
                  >
                    <PreferenceDataComponent
                      prefCategory={props.category}
                      prefId={k}
                    />
                  </LabeledList.Item>
                );
              },
            )}
          </LabeledList>
        );
      }}
    />
  );
};
