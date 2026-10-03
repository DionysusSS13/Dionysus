import { binaryInsertWith, sortBy } from 'common/collections';
import { ReactNode } from 'react';
import { Tooltip } from 'tgui-core/components';

import { useBackend } from '../../backend';
import { Box, Flex } from '../../components';
import { PreferenceData, PreferencesMenuData } from './data';
import { FeatureValueInput } from './preferences/features/base';
import { FEATURE_ID_TO_COMPONENT } from './PreferenceTypes';
import { ServerPreferencesFetcher } from './ServerPreferencesFetcher';
import { TabbedMenu } from './TabbedMenu';

type PreferenceChild = {
  children: ReactNode;
  name: string;
};

const binaryInsertPreference = binaryInsertWith<PreferenceChild>(
  (child) => child.name,
);

const sortByName = sortBy<[string, PreferenceChild[]]>(([name]) => name);

export const GamePreferencesPage = (props) => {
  const { act, data } = useBackend<PreferencesMenuData>();

  const gamePreferences: Record<string, PreferenceChild[]> = {};

  return (
    <ServerPreferencesFetcher
      render={(serverData) => {
        if (!serverData) {
          return;
        }

        for (const entry of Object.entries(data.player_preferences)) {
          // This isn't ideal. I stopped caring 3 hours ago.
          let entryEntries = Object.entries(entry);
          const category = (entryEntries[0][1] as string) || 'ERROR';
          const preferences = entryEntries[1][1];
          if (!preferences) {
            continue;
          }
          for (const [prefId, value] of Object.entries(preferences)) {
            const prefEntry = serverData[prefId] as PreferenceData | undefined;
            if (!prefEntry) {
              continue;
            }

            const feature = FEATURE_ID_TO_COMPONENT[prefEntry!!.feature];

            let nameInner: ReactNode = prefEntry?.name || prefId;

            if (prefEntry.description) {
              nameInner = (
                <Box
                  as="span"
                  style={{
                    borderBottom: '2px dotted rgba(255, 255, 255, 0.8)',
                  }}
                >
                  {nameInner}
                </Box>
              );
            }

            let name: ReactNode = (
              <Flex.Item grow={1} pr={2} basis={0} ml={2}>
                {nameInner}
              </Flex.Item>
            );

            if (prefEntry.description) {
              name = (
                <Tooltip
                  content={prefEntry.description}
                  position="bottom-start"
                >
                  {name}
                </Tooltip>
              );
            }

            const child = (
              <Flex align="center" key={prefId} pb={2}>
                {name}

                <Flex.Item grow={1} basis={0}>
                  {(feature && (
                    <FeatureValueInput
                      feature={feature}
                      featureId={prefId}
                      value={value}
                      act={act}
                    />
                  )) || (
                    <Box as="b" color="red">
                      ...is not filled out properly!!!
                    </Box>
                  )}
                </Flex.Item>
              </Flex>
            );

            const entry = {
              name: feature?.name || prefId,
              children: child,
            };

            gamePreferences[category] = binaryInsertPreference(
              gamePreferences[category] || [],
              entry,
            );
          }
        }

        const gamePreferenceEntries: [string, ReactNode][] = sortByName(
          Object.entries(gamePreferences),
        ).map(([category, preferences]) => {
          return [category, preferences.map((entry) => entry.children)];
        });

        return (
          <TabbedMenu
            categoryEntries={gamePreferenceEntries}
            contentProps={{
              fontSize: 1.5,
            }}
          />
        );
      }}
    />
  );
};
