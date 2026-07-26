import { useBackend, useLocalState } from '../../backend';
import {
  Box,
  Button,
  Dimmer,
  Section,
  Stack,
  TextArea,
} from '../../components';
import { LoadCursor } from '../../components/LoadCursor';
import { PreferencesMenuData } from './data';
import { ServerData } from './data';
import { AllFeaturesInCategory } from './PreferenceTypes';
import { ServerPreferencesFetcher } from './ServerPreferencesFetcher';

export const LorePage = (props) => {
  const { data, act } = useBackend<PreferencesMenuData>();
  const [editing, setEditing] = useLocalState<string | null>(
    'lore_editing_record',
    null,
  );

  return (
    <ServerPreferencesFetcher
      render={(serverData) => {
        if (!serverData) {
          return;
        }

        return (
          <Stack fill vertical>
            <Stack.Item width="100%">
              <Stack fill>
                <Stack.Item width="100%">
                  <Section title="Employee PII" fill>
                    <AllFeaturesInCategory category="pii" />
                  </Section>
                </Stack.Item>
                <Stack.Item width="100%">
                  <Section title="Loyalties" fill>
                    <AllFeaturesInCategory category="loyalties" />
                  </Section>
                </Stack.Item>
              </Stack>
            </Stack.Item>
            <Stack.Item width="100%">
              <Stack fill>
                <Stack.Item width="100%">
                  <Section title="Aliases & Affiliations" fill>
                    <AllFeaturesInCategory category="aliases_affiliations" />
                  </Section>
                </Stack.Item>
                <Stack.Item width="100%">
                  <Section title="Meta" fill>
                    <AllFeaturesInCategory category="meta" />
                  </Section>
                </Stack.Item>
              </Stack>
            </Stack.Item>
            <Stack.Item>
              <Stack fill vertical>
                <Stack.Item
                  style={{ display: 'flex', justifyContent: 'center' }}
                >
                  <Button big onClick={() => setEditing('medical_record')}>
                    Update Medical Records
                  </Button>
                  <Button big onClick={() => setEditing('security_record')}>
                    Update Security Records
                  </Button>
                  <Button big onClick={() => setEditing('exploitable_record')}>
                    Update Exploitable Records
                  </Button>
                </Stack.Item>
                <Stack.Item
                  style={{ display: 'flex', justifyContent: 'center' }}
                >
                  <Button big onClick={() => setEditing('station_record')}>
                    Update Station Records
                  </Button>
                  <Button big onClick={() => setEditing('sealed_record')}>
                    Update Sealed Records
                  </Button>
                </Stack.Item>
              </Stack>
            </Stack.Item>
            {editing && (
              <RecordEditorModal
                prefId={editing}
                serverData={serverData}
                onClose={() => {
                  setEditing(null);
                }}
                onSubmit={(text) => {
                  act('set_preference', {
                    preference: editing,
                    value: text,
                  });
                  setEditing(null);
                }}
              />
            )}
          </Stack>
        );
      }}
    />
  );
};

export const RecordEditorModal = (props: {
  onClose: () => void;
  onSubmit: (text: string) => void;
  prefId: string;
  serverData: ServerData;
}) => {
  const { data, act } = useBackend<PreferencesMenuData>();
  const { onClose, onSubmit, prefId, serverData } = props;
  const prefData = serverData[prefId];
  const maxLength = prefData?.max_length as number | undefined;
  const [text, setText] = useLocalState<string>(
    `dioPrefs_${prefId}`,
    data.character_preferences.misc[prefId] as string,
  );

  return (
    <Dimmer>
      <LoadCursor width="75rem" height="50rem">
        <Box width="75rem" height="50rem" className="Modal">
          <Stack fill vertical>
            <Stack.Item height="100%">
              <Section title={`Update ${prefData?.name}`} fill>
                <TextArea
                  monospace
                  autoFocus
                  fluid
                  height="100%"
                  maxLength={maxLength}
                  onEscape={onClose}
                  onEnter={onClose}
                  onChange={(_, value) => {
                    setText(value);
                    act('set_preference', {
                      preference: prefId,
                      value: value,
                    });
                  }}
                  value={text}
                />
              </Section>
            </Stack.Item>
            <Stack.Item>
              <Stack fill>
                <Stack.Item grow textColor="#666" /* ooOooo spooooky */>
                  <sup>Shift+Enter to insert new lines</sup>
                </Stack.Item>
                <Stack.Item>
                  <Button color="good" onClick={() => onSubmit(text)}>
                    Done
                  </Button>
                </Stack.Item>
              </Stack>
            </Stack.Item>
          </Stack>
        </Box>
      </LoadCursor>
    </Dimmer>
  );
};
