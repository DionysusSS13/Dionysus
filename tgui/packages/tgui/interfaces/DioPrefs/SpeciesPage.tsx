import { FA_ICON_EXTERNAL_LINK, FA_ICON_X } from 'common/fa_icons';
import { Box, Tooltip } from 'tgui-core/components';

import { useBackend, useLocalState } from '../../backend';
import { Button, Icon, Stack } from '../../components';
import { PreferencesMenuData, Trait } from './data';
import { ServerPreferencesFetcher } from './ServerPreferencesFetcher';

export const SpeciesPage = (props) => {
  const { data } = useBackend<PreferencesMenuData>();

  const [previewSpecies, setPreviewSpecies] = useLocalState(
    'DioPrefs_previewSpecies',
    data.character_preferences.misc.species || 'human',
  );

  let index = 0;
  const maxDepth = 8;

  return (
    <ServerPreferencesFetcher
      render={(serverData) => {
        const calcDepth = () => {
          return (
            (index / (Object.values(serverData?.species!!).length * 4)) *
            maxDepth
          );
        };

        if (!serverData) {
          return;
        }

        const selectedSpecies = serverData.species[previewSpecies];

        return (
          <Stack fill>
            <Stack.Item width="120px" mr="0">
              <Stack vertical>
                {Object.entries(serverData?.species).map(([key, species]) => {
                  index++;
                  const depth = calcDepth();
                  return (
                    <Stack.Item key={key}>
                      <Button
                        style={{
                          display: 'flex',
                          justifySelf: 'flex-end',
                          boxShadow: `0 ${depth}px ${depth}px black`,
                        }}
                        mr="0"
                        onClick={() => setPreviewSpecies(key)}
                        selected={key === previewSpecies}
                      >
                        {species.name}
                      </Button>
                    </Stack.Item>
                  );
                })}
              </Stack>
            </Stack.Item>
            <Stack.Item width="100%" ml="0" style={{ zIndex: '1' }}>
              <Box
                backgroundColor="#c9c28fff"
                color="black"
                width="100%"
                height="100%"
                p="5px"
              >
                <Stack vertical height="100%">
                  <Stack.Item>
                    <h1 style={{ textAlign: 'center' }}>
                      {selectedSpecies.name}
                    </h1>

                    <Box className="InlineTooltip">
                      Is{' '}
                      <Tooltip content="Separate sprites for male and female">
                        dimorphic
                      </Tooltip>
                      : {selectedSpecies.sexes ? 'Yes' : 'No'}
                    </Box>

                    <h2>Description:</h2>
                    <Box preserveWhitespace>
                      {selectedSpecies.desc.join('\n')}
                    </Box>

                    <h2>Lore:</h2>
                    <Box preserveWhitespace>
                      {selectedSpecies.lore.join('\n')}
                    </Box>

                    <h2>Notable Traits:</h2>

                    <Stack vertical>
                      <Stack.Item>
                        <Stack>
                          <Stack.Item width="50px">Positive</Stack.Item>
                          <Stack.Item
                            width="50px"
                            ml="auto"
                            mr="auto"
                            textAlign="center"
                          >
                            Neutral
                          </Stack.Item>
                          <Stack.Item
                            width="50px"
                            textAlign="right"
                            mr="0.25rem"
                            ml="0"
                          >
                            Negative
                          </Stack.Item>
                        </Stack>
                      </Stack.Item>
                      <Stack.Divider
                        style={{
                          borderTop: 'none',
                          background:
                            'linear-gradient(to right, green 0%, gray 50%, red 100%)',
                          height: '2px',
                        }}
                      />
                      <Stack.Item>
                        <Stack width="100%">
                          <Stack.Item>
                            {!!selectedSpecies.traits.positive &&
                              Object.entries(
                                selectedSpecies.traits.positive,
                              ).map(([_, t]) => (
                                <TraitEntry
                                  key={t.name}
                                  trait={t}
                                  type="positive"
                                />
                              ))}
                          </Stack.Item>
                          <Stack.Item ml="auto" mr="auto">
                            {!!selectedSpecies.traits.neutral &&
                              Object.entries(
                                selectedSpecies.traits.neutral,
                              ).map(([_, t]) => (
                                <TraitEntry
                                  key={t.name}
                                  trait={t}
                                  type="neutral"
                                />
                              ))}
                          </Stack.Item>
                          <Stack.Item>
                            {!!selectedSpecies.traits.negative &&
                              Object.entries(
                                selectedSpecies.traits.negative,
                              ).map(([_, t]) => (
                                <TraitEntry
                                  key={t.name}
                                  trait={t}
                                  type="negative"
                                />
                              ))}
                          </Stack.Item>
                        </Stack>
                      </Stack.Item>
                    </Stack>
                  </Stack.Item>

                  <Stack.Item mt="auto" position="relative" height="40px">
                    <Button
                      position="absolute"
                      left="0"
                      className="Button--big"
                    >
                      Confirm
                    </Button>
                    <a
                      href={
                        'https://wiki.dionysus13.net/wiki/Species/' +
                        data.character_preferences.misc.species
                      }
                      style={{
                        textDecoration: 'none',
                      }}
                    >
                      <Button position="absolute" right="0">
                        Read more on the DioBase{' '}
                        <Icon name={FA_ICON_EXTERNAL_LINK} />
                      </Button>
                    </a>
                  </Stack.Item>
                </Stack>
              </Box>
            </Stack.Item>
          </Stack>
        );
      }}
    />
  );
};

const TraitEntry = (props: { trait: Trait; type: string }) => {
  return (
    <Box className={'DioPrefs__Trait DioPrefs__Trait_' + props.type}>
      <Tooltip
        content={
          <Box>
            <b>{props.trait.name}</b>
            <br />
            {props.trait.description}
          </Box>
        }
      >
        <Icon name={props.trait.icon || FA_ICON_X} />
      </Tooltip>
    </Box>
  );
};
