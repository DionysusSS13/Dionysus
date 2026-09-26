import { FA_ICON_EXTERNAL_LINK, FA_ICON_X } from 'common/fa_icons';
import { Box, Tooltip } from 'tgui-core/components';

import { useBackend, useLocalState } from '../../backend';
import { Button, Icon, Stack } from '../../components';
import { PreferencesMenuData, Species, SpeciesList, Trait } from './data';
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
        if (!serverData) {
          return;
        }

        const { act } = useBackend();

        const calcDepth = () => {
          return (
            (index / (Object.values(serverData.species).length * 4)) * maxDepth
          );
        };

        const selectedSpecies = findSpecies(serverData.species, previewSpecies);

        return (
          <Stack fill>
            <Stack.Item width="250px" mr="0">
              <Stack vertical className="DioPrefs__Species__Select">
                {Object.entries(serverData?.species).map(([key, species]) => {
                  index++;
                  const depth = calcDepth();
                  return (
                    <SpeciesButton
                      shadowDepth={depth}
                      key={key}
                      speciesId={key}
                      selected={key === previewSpecies}
                      species={species}
                      previewSpecies={previewSpecies}
                      setPreviewSpecies={setPreviewSpecies}
                      depth={0}
                    />
                  );
                })}
              </Stack>
            </Stack.Item>
            <Stack.Item width="100%" ml="0" style={{ zIndex: '1' }}>
              <Box className="DioPrefs__Species__MainPage">
                {selectedSpecies && (
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
                        onClick={() =>
                          act('set_preference', {
                            preference: 'species',
                            value: previewSpecies,
                          })
                        }
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
                )}
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

const SpeciesButton = (props: {
  depth: number;
  previewSpecies: string;
  selected: boolean;
  setPreviewSpecies: (nextState: string) => void;
  shadowDepth: number;
  species: Species;
  speciesId: string;
}) => {
  const {
    shadowDepth,
    speciesId,
    selected,
    species,
    previewSpecies,
    setPreviewSpecies,
    depth,
  } = props;
  return (
    <Stack.Item style={{ display: 'flex', justifyContent: 'flex-end' }}>
      <Stack vertical>
        <Stack.Item>
          <Button
            style={{
              display: 'flex',
              justifySelf: 'flex-end',
              boxShadow: `0 ${shadowDepth}px ${shadowDepth}px black`,
              whiteSpace: 'preserve',
              padding: depth === 0 && '6px 12px',
            }}
            mr="0"
            onClick={() => setPreviewSpecies(speciesId)}
            selected={selected}
          >
            <Box
              style={{
                filter: `brightness(${1 - depth * 0.2})`,
                fontSize: `${14 - depth * 2}px`,
              }}
            >
              {species.name}
            </Box>
          </Button>
        </Stack.Item>

        {species.subspecies &&
          Object.entries(species.subspecies).map(([key, value]) => {
            return (
              <Stack.Item key={key} mt="2px">
                <SpeciesButton
                  previewSpecies={previewSpecies}
                  selected={previewSpecies === key}
                  shadowDepth={1}
                  speciesId={key}
                  species={value}
                  setPreviewSpecies={setPreviewSpecies}
                  depth={depth + 1}
                />
              </Stack.Item>
            );
          })}
      </Stack>
    </Stack.Item>
  );
};

const getAllSpecies = (species: Species) => {
  if (!species.subspecies) {
    return [];
  }
  let speciesList = structuredClone(species.subspecies);
  Object.entries(species.subspecies).forEach(([k, v]) => {
    speciesList[k] = v;
    if (v.subspecies) {
      Object.entries(getAllSpecies(v)).forEach(([k, v]) => {
        speciesList[k] = v;
      });
    }
  });
  return speciesList;
};

const findSpecies = (
  speciesList: SpeciesList,
  speciesId: string,
): Species | undefined => {
  console.log('test');
  const result = Object.entries(speciesList)
    .flatMap(([k, v]) => {
      const species = getAllSpecies(v);
      species[k] = v;
      return Object.entries(species);
    })
    .find(([k, _]) => {
      return k === speciesId;
    });
  console.log(result);
  return result?.[1];
};

const subspeciesAmount = (species: Species) => {
  if (!species.subspecies) {
    return 0;
  }

  let amount = 0;

  Object.entries(species.subspecies).forEach(([_, value]) => {
    amount++;
    amount += subspeciesAmount(value);
  });

  return amount;
};
