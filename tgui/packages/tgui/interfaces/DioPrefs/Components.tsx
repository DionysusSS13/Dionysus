import { classes } from 'common/react';
import { createSearch } from 'common/string';
import React, { useState } from 'react';
import { Popper } from 'tgui-core/components';

import { useBackend } from '../../backend';
import {
  Autofocus,
  Box,
  Button,
  Flex,
  Input,
  LabeledList,
  Stack,
  TrackOutsideClicks,
} from '../../components';
import { PreferencesMenuData, RandomSetting } from './data';
import {
  FeatureChoicedServerData,
  FeatureValueInput,
  SupplementalFeature,
} from './preferences/features/base';
import { FEATURE_ID_TO_COMPONENT } from './PreferenceTypes';
import { RandomizationButton } from './RandomizationButton';
import { ServerPreferencesFetcher } from './ServerPreferencesFetcher';

const CLOTHING_CELL_INNER_SIZE = 64;
const CLOTHING_CELL_PADDING = 0;
const CLOTHING_CELL_SIZE = CLOTHING_CELL_INNER_SIZE + CLOTHING_CELL_PADDING;

const CLOTHING_SELECTION_CELL_SIZE =
  CLOTHING_CELL_INNER_SIZE + CLOTHING_CELL_PADDING;
const CLOTHING_SELECTION_WIDTH = 4; // in slots
const CLOTHING_SELECTION_HEIGHT = 5.2; // uuhhh, pretty much arbitrary, have fun :)

export const MainFeature = (props: {
  catalog: FeatureChoicedServerData;
  currentValue: string;
  handleClose: () => void;
  handleOpen: () => void;
  handleSelect: (newClothing: string) => void;
  isEven?: boolean;
  isOpen: boolean;
  randomization?: RandomSetting;
  setRandomization: (newSetting: RandomSetting) => void;
}) => {
  const { act, data } = useBackend<PreferencesMenuData>();

  const {
    catalog,
    currentValue,
    isOpen,
    handleOpen,
    handleClose,
    handleSelect,
    randomization,
    setRandomization,
    isEven,
  } = props;

  return (
    <Flex
      inline
      width="50%"
      height={`${CLOTHING_CELL_SIZE}px`}
      position="relative"
      className="DioPrefs__PopperContainer"
    >
      <Popper
        isOpen={isOpen}
        placement={
          // I HATE byondui
          isEven ? 'bottom-start' : 'bottom-end'
        }
        content={
          isOpen && (
            <TrackOutsideClicks onOutsideClick={props.handleClose}>
              <ChoicedSelection
                name={catalog.name!!}
                catalog={catalog}
                selected={currentValue}
                supplementalFeatures={catalog.supplemental_features}
                onClose={handleClose}
                onSelect={handleSelect}
              />
            </TrackOutsideClicks>
          )
        }
      >
        <Box inline>
          <Button
            onClick={(e) => {
              e.stopPropagation();
              if (isOpen) {
                handleClose();
              } else {
                handleOpen();
              }
            }}
            style={{
              height: `${CLOTHING_CELL_SIZE}px`,
              width: `${CLOTHING_CELL_SIZE}px`,
            }}
            position="relative"
            tooltipPosition="right"
            selected={props.isOpen}
          >
            <Box
              className={classes([
                'preferences32x32',
                catalog.icons ? catalog.icons[currentValue] : '',
                'centered-image',
              ])}
              style={{
                colorInterpolation: 'nearest-neighbor',
                transform: `translateX(-50%) translateY(-50%) scale(${CLOTHING_CELL_INNER_SIZE / 32})`,
              }}
            />

            {randomization && (
              <RandomizationButton
                dropdownProps={{
                  dropdownStyle: {
                    bottom: 0,
                    position: 'absolute',
                    right: '1px',
                  },

                  onOpen: (event) => {
                    // We're a button inside a button.
                    // Did you know that's against the W3C standard? :)
                    event.cancelBubble = true;
                    event.stopPropagation();
                  },
                }}
                value={randomization}
                setValue={setRandomization}
              />
            )}
          </Button>
        </Box>
        <Box
          position="absolute"
          height="100%"
          verticalAlign="top"
          style={{
            display: 'inline-flex',
            alignItems: 'center',
          }}
          width={`calc(100% - ${CLOTHING_CELL_SIZE}px)`} // Agony
        >
          <Box inline>
            <span>{catalog.name}</span>
            <br />
            <span style={{ color: 'grey' }}>{currentValue}</span>
          </Box>
        </Box>
      </Popper>
    </Flex>
  );
};

const ChoicedSelection = (props: {
  catalog: FeatureChoicedServerData;
  name: string;
  onClose: () => void;
  onSelect: (value: string) => void;
  selected: string;
  supplementalFeatures?: SupplementalFeature[];
}) => {
  const { act, data } = useBackend<PreferencesMenuData>();
  const [searchTerm, setSearchTerm] = useState<string>('');

  const { catalog, supplementalFeatures } = props;

  let selectedIndex = catalog.choices.findIndex((e) => e === props.selected);

  if (!catalog.icons) {
    return <Box color="red">Provided catalog had no icons!</Box>;
  }

  return (
    <ServerPreferencesFetcher
      render={(serverData) => (
        <Box
          className="DioPrefs__PartSelector"
          style={{
            height: `${
              CLOTHING_SELECTION_CELL_SIZE * CLOTHING_SELECTION_HEIGHT + 4
            }px`,
            width: `${CLOTHING_SELECTION_CELL_SIZE * CLOTHING_SELECTION_WIDTH + 72}px`,
          }}
        >
          <Box
            className="DioPrefs__PartSelector__inner"
            style={{
              height: `${
                CLOTHING_SELECTION_CELL_SIZE * CLOTHING_SELECTION_HEIGHT
              }px`,
              width: `${CLOTHING_SELECTION_CELL_SIZE * CLOTHING_SELECTION_WIDTH + 68}px`,
            }}
          >
            <Stack vertical fill>
              <Stack.Item pl="4px" pr="4px" pt="4px">
                <Stack fill p="40px">
                  <Stack.Item>
                    <Button
                      icon="arrow-left"
                      onClick={() =>
                        props.onSelect(
                          catalog.choices[
                            selectedIndex - 1 < 0
                              ? catalog.choices.length - 1
                              : selectedIndex - 1
                          ],
                        )
                      }
                    />
                    <Button
                      icon="arrow-right"
                      onClick={() =>
                        props.onSelect(
                          catalog.choices[
                            selectedIndex + 2 > catalog.choices.length
                              ? 0
                              : selectedIndex + 1
                          ],
                        )
                      }
                    />
                  </Stack.Item>
                  <Stack.Item grow>
                    <Box
                      style={{
                        borderBottom: '1px solid #888',
                        fontWeight: 'bold',
                        fontSize: '14px',
                        textAlign: 'center',
                      }}
                    >
                      Select {props.name?.toLowerCase()}
                    </Box>
                  </Stack.Item>

                  <Stack.Item>
                    <Button color="red" onClick={props.onClose}>
                      X
                    </Button>
                  </Stack.Item>
                </Stack>
              </Stack.Item>
              {supplementalFeatures && (
                <Stack.Item pl="4px" pr="4px">
                  <LabeledList>
                    {supplementalFeatures.map((feature) => (
                      <LabeledList.Item
                        key={feature.key}
                        label={
                          (serverData &&
                            (serverData[feature.key] as Record<string, string>)
                              ?.name) ||
                          (feature.feature === 'tri_color' && 'Part Color')
                        }
                      >
                        <FeatureValueInput
                          act={(action, data) => {
                            act(action, data);
                          }}
                          feature={FEATURE_ID_TO_COMPONENT[feature.feature]}
                          featureId={feature.key}
                          shrink
                          value={
                            data.character_preferences.supplemental_features[
                              feature.key
                            ]
                          }
                        />
                      </LabeledList.Item>
                    ))}
                  </LabeledList>
                </Stack.Item>
              )}

              <Stack.Item>
                <Input
                  placeholder="Search..."
                  style={{
                    margin: '0px 5px',
                    width: '95%',
                  }}
                  onInput={(_, value) => setSearchTerm(value)}
                />
              </Stack.Item>

              <Stack.Item overflowX="hidden" overflowY="scroll" height="100%">
                <Autofocus>
                  <Flex wrap>
                    {catalog?.icons &&
                      searchInCatalog(searchTerm, catalog.icons).map(
                        ([name, image], index) => {
                          return (
                            <Flex.Item
                              key={index}
                              basis={`${CLOTHING_SELECTION_CELL_SIZE}px`}
                              style={{
                                padding: '5px',
                              }}
                            >
                              <Button
                                onClick={() => {
                                  props.onSelect(name);
                                }}
                                selected={name === props.selected}
                                tooltip={name}
                                tooltipPosition="right"
                                style={{
                                  height: `${CLOTHING_SELECTION_CELL_SIZE}px`,
                                  width: `${CLOTHING_SELECTION_CELL_SIZE}px`,
                                }}
                              >
                                <Box
                                  className={classes([
                                    'preferences32x32',
                                    image,
                                    'centered-image',
                                  ])}
                                  style={{
                                    transform: `translateX(-50%) translateY(-50%) scale(${CLOTHING_CELL_INNER_SIZE / 32})`,
                                  }}
                                />
                              </Button>
                            </Flex.Item>
                          );
                        },
                      )}
                  </Flex>
                </Autofocus>
              </Stack.Item>
            </Stack>
          </Box>
        </Box>
      )}
    />
  );
};

const searchInCatalog = (searchText = '', catalog: Record<string, string>) => {
  let items = Object.entries(catalog);
  if (searchText) {
    items = items.filter(createSearch(searchText, ([name, _icon]) => name));
  }
  return items;
};
