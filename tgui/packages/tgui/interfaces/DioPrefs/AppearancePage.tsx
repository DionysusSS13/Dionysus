import { useState } from 'react';

import { useBackend } from '../../backend';
import { Box, LabeledList, Section, Stack } from '../../components';
import { CharacterDoll, Part } from '../../components/CharacterDoll';
import { MainFeature } from './Components';
import { createSetPreference, PreferencesMenuData } from './data';
import {
  FeatureChoicedServerData,
  FeatureValueInput,
} from './preferences/features/base';
import { FEATURE_ID_TO_COMPONENT } from './PreferenceTypes';
import { ServerPreferencesFetcher } from './ServerPreferencesFetcher';

// These consts make thinking about this 1000% easier.
const DOLL_SIZE = 32 * 14; // Each sprite pixel is 14x14 screen pixels
const CENTER = 32 * 0.484375; // The weird decimal is cause human sprites are an odd number wide on an even canvas

export const AppearancePage = (props) => {
  const { data, act } = useBackend<PreferencesMenuData>();
  const [selectedPart, setSelectedPart] = useState<null | Part>(null);
  const [currentFeatureMenu, setCurrentFeatureMenu] = useState<null | string>(
    null,
  );

  return (
    <ServerPreferencesFetcher
      render={(serverData) => {
        return (
          <Stack fill>
            <Stack.Item width="50%">
              <Box mt="20%">
                <CharacterDoll
                  selectedPart={selectedPart}
                  setSelectedPart={setSelectedPart}
                  dollSize={DOLL_SIZE}
                  parts={parts}
                  center={CENTER}
                />
              </Box>
            </Stack.Item>
            <Stack.Item width="50%">
              <Stack vertical>
                <Stack.Item>
                  <Section
                    title={
                      selectedPart
                        ? `Organs of ${selectedPart?.name}`
                        : 'General Organs (Would There Even Be Any??)'
                    }
                  >
                    {!!serverData &&
                      !!data.character_preferences[
                        selectedPart ? selectedPart.id : 'general'
                      ] &&
                      Object.entries(
                        data.character_preferences[
                          selectedPart ? selectedPart.id : 'general'
                        ],
                      )
                        .filter(
                          (e) =>
                            (serverData[e[0]] as FeatureChoicedServerData)
                              .feature === 'icon_box',
                        )
                        .map((feature, index) => {
                          const [id, value] = feature;
                          return (
                            <MainFeature
                              key={id}
                              catalog={
                                serverData[id] as FeatureChoicedServerData
                              }
                              currentValue={value as string /* yolo */}
                              handleClose={() => {
                                setCurrentFeatureMenu(null);
                              }}
                              handleOpen={() => {
                                setCurrentFeatureMenu(id);
                              }}
                              handleSelect={createSetPreference(act, id)}
                              isOpen={currentFeatureMenu === id}
                              setRandomization={() => {}}
                              isEven={index % 2 === 0}
                            />
                          );
                        })}
                  </Section>
                </Stack.Item>
                <Stack.Item>
                  <Section
                    title={
                      selectedPart
                        ? `Limb Options for ${selectedPart?.name}`
                        : 'General Options'
                    }
                  >
                    <LabeledList>
                      {!!serverData &&
                        !!data.character_preferences[
                          selectedPart ? selectedPart.id : 'general'
                        ] &&
                        Object.entries(
                          data.character_preferences[
                            selectedPart ? selectedPart.id : 'general'
                          ],
                        )
                          .filter(
                            (e) =>
                              (serverData[e[0]] as FeatureChoicedServerData)
                                .feature !== 'icon_box',
                          )
                          .map((feature) => {
                            const [id, value] = feature;
                            const featureProps = serverData[
                              id
                            ] as FeatureChoicedServerData;
                            return (
                              <LabeledList.Item
                                key={feature[0]}
                                label={
                                  featureProps.name ||
                                  (featureProps.feature === 'tri_color' &&
                                    'Part Color')
                                }
                              >
                                <FeatureValueInput
                                  act={(action, data) => {
                                    act(action, data);
                                  }}
                                  feature={
                                    FEATURE_ID_TO_COMPONENT[
                                      featureProps.feature
                                    ]
                                  }
                                  featureId={id}
                                  shrink
                                  value={value}
                                />
                              </LabeledList.Item>
                            );
                          })}
                    </LabeledList>
                  </Section>
                </Stack.Item>
              </Stack>
            </Stack.Item>
          </Stack>
        );
      }}
    />
  );
};

// These are all in sprite-space pixels
// The positions of these should *probably* be DM-controlled in the future for species specific stuff...
// but I honestly don't see any species bucking this trend for now, and this has less moving parts.
const parts: Part[] = [
  {
    id: 'head',
    name: 'Head',
    pos: { x: CENTER, y: 6, width: 10, height: 10 },
  },
  {
    id: 'left_arm',
    name: 'Left Arm',
    pos: { x: CENTER + 7, y: 17, width: 5, height: 12 },
  },
  {
    id: 'right_arm',
    name: 'Right Arm',
    pos: { x: CENTER - 7, y: 17, width: 5, height: 12 },
  },
  {
    id: 'groin',
    name: 'Groin',
    pos: { x: CENTER, y: 22, width: 9, height: 4 },
  },
  {
    id: 'torso',
    name: 'Torso',
    pos: { x: CENTER, y: 15.5, width: 9, height: 9 },
  },
  {
    id: 'left_leg',
    name: 'Left Leg',
    pos: { x: CENTER + 5, y: 28, width: 10, height: 8 },
  },
  {
    id: 'right_leg',
    name: 'Right Leg',
    pos: { x: CENTER - 5, y: 28, width: 10, height: 8 },
  },
];
