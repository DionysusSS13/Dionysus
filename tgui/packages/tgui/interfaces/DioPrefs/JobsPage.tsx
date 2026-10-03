import { FA_ICON_EXTERNAL_LINK } from 'common/fa_icons';
import { classes } from 'common/react';

import { useBackend, useLocalState } from '../../backend';
import {
  Box,
  Button,
  Dropdown,
  Icon,
  NoticeBox,
  Stack,
} from '../../components';
import { Job, JobPriority, PreferencesMenuData, ServerData } from './data';
import { ServerPreferencesFetcher } from './ServerPreferencesFetcher';

const JOB_PORTRAIT_SIZE = 160;
const PRIORITY_BUTTON_SIZE = 14;

export const JobsPage = (props) => {
  const { act, data } = useBackend<PreferencesMenuData>();

  return (
    <ServerPreferencesFetcher
      render={(serverData) => {
        if (!serverData) {
          return;
        }

        const [selectedJob] = useLocalState<string>(
          'DioPrefs_selectedJob',
          Object.keys(serverData.jobs.jobs)[0],
        );

        const selectedJobObj = serverData.jobs.jobs[selectedJob];
        const alternateTitles =
          data.character_preferences.misc.alternate_titles || {};

        let canShowTitles = true;

        return (
          <Stack fill>
            <Stack.Item width="40%" height="100%">
              <Box overflowY="scroll" height="730px">
                {Object.entries(serverData.jobs.jobs).map(([jobId, job]) => {
                  return (
                    <JobListEntry
                      key={jobId}
                      job={job}
                      jobId={jobId}
                      serverData={serverData}
                    />
                  );
                })}
              </Box>
            </Stack.Item>
            <Stack.Item width="100%" height="100%">
              <Stack vertical fill>
                <Stack.Item>
                  <h1 style={{ textAlign: 'center' }}>
                    {selectedJobObj.display_title}
                  </h1>
                </Stack.Item>
                {data.jobs[selectedJob]?.banned && !(canShowTitles = false) && (
                  <Stack.Item>
                    <NoticeBox color="bad">
                      You are banned from this job.
                    </NoticeBox>
                  </Stack.Item>
                )}
                {!!data.jobs[selectedJob]?.account_days_left &&
                  !(canShowTitles = false) && (
                    <Stack.Item>
                      <NoticeBox>
                        Your account is too new! (
                        {data.jobs[selectedJob]?.account_days_left} days left
                        for this job.)
                      </NoticeBox>
                    </Stack.Item>
                  )}
                {!!data.jobs[selectedJob]?.playtime_required.time_left &&
                  !(canShowTitles = false) && (
                    <Stack.Item>
                      <NoticeBox>
                        You need more department playtime in{' '}
                        {data.jobs[selectedJob]?.playtime_required.department}!
                        (
                        {Math.round(
                          (data.jobs[selectedJob]?.playtime_required.time_left /
                            60) *
                            100,
                        ) / 100}{' '}
                        hours left for this job.)
                      </NoticeBox>
                    </Stack.Item>
                  )}
                {canShowTitles && selectedJobObj.alt_titles.length > 1 && (
                  <Stack.Item
                    style={{ display: 'flex', justifyContent: 'center' }}
                  >
                    <Dropdown
                      width="200px"
                      options={selectedJobObj.alt_titles}
                      selected={
                        alternateTitles[selectedJob] ||
                        selectedJobObj.display_title
                      }
                      onSelected={(value) => {
                        const alt_titles = alternateTitles || {};
                        alt_titles[selectedJob] = value;
                        act('set_preference', {
                          preference: 'alternate_titles',
                          value: alt_titles,
                        });
                      }}
                    />
                  </Stack.Item>
                )}
                <Stack.Item>
                  <Stack>
                    <Stack.Item
                      position="relative"
                      width={`${JOB_PORTRAIT_SIZE}px`}
                      height={`${JOB_PORTRAIT_SIZE}px`}
                    >
                      <Box
                        className={`preferences32x32 job___${selectedJobObj.css_class}`}
                        style={{
                          scale: `${JOB_PORTRAIT_SIZE / 32}`,
                        }}
                        position="absolute"
                        left={`${(JOB_PORTRAIT_SIZE / 32 - (JOB_PORTRAIT_SIZE / 32 - 2)) * 32}px`}
                        top={`${(JOB_PORTRAIT_SIZE / 32 - (JOB_PORTRAIT_SIZE / 32 - 2)) * 32}px`}
                      />
                    </Stack.Item>
                    <Stack.Item preserveWhitespace>
                      {selectedJobObj.description.join('\n')}
                    </Stack.Item>
                  </Stack>
                  <Stack.Item preserveWhitespace>
                    {selectedJobObj.flavor.join('\n')}
                  </Stack.Item>
                  <Stack.Item>
                    <ul>
                      {selectedJobObj.tips.map((e) => (
                        <li key={e}>{e}</li>
                      ))}
                    </ul>
                  </Stack.Item>
                </Stack.Item>

                <Stack.Item mt="auto" position="relative" height="40px">
                  <a
                    href={
                      'https://wiki.dionysus13.net/wiki/Jobs/' +
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
            </Stack.Item>
          </Stack>
        );
      }}
    />
  );
};

const setJobPriority = (job: string, priority?: JobPriority) => {
  const { act, data } = useBackend<PreferencesMenuData>();
  const job_priority: Record<string, number> =
    data.character_preferences.misc.job_priority || {};

  if (!priority) {
    delete job_priority[job];
  } else {
    job_priority[job] = priority;
    if (priority === 3) {
      for (const [jobId, value] of Object.entries(job_priority)) {
        if (jobId !== job && value === 3) {
          job_priority[jobId] = 2;
        }
      }
    }
  }

  act('set_preference', {
    preference: 'job_priority',
    value: job_priority,
  });
};

const PriorityButton = (props: {
  color: string;
  enabled: boolean;
  modifier?: string;
  name: string;
  onClick: () => void;
}) => {
  const className = `DioPrefs__Job__priority`;

  return (
    <Stack.Item height={`${PRIORITY_BUTTON_SIZE}px`}>
      <Button
        className={classes([
          className,
          props.modifier && `${className}--${props.modifier}`,
        ])}
        color={props.enabled ? props.color : 'white'}
        onClick={props.onClick}
        tooltip={props.name}
        tooltipPosition="bottom"
        height={`${PRIORITY_BUTTON_SIZE}px`}
        width={`${PRIORITY_BUTTON_SIZE}px`}
      />
    </Stack.Item>
  );
};

const JobListEntry = (props: {
  job: Job;
  jobId: string;
  serverData: ServerData;
}) => {
  const { serverData, jobId, job } = props;

  const { data } = useBackend<PreferencesMenuData>();

  const [selectedJob, setSelectedJob] = useLocalState<string>(
    'DioPrefs_selectedJob',
    Object.keys(serverData.jobs.jobs)[0],
  );
  const priorities = data.character_preferences.misc.job_priority || [];

  const cantPlay =
    data.jobs[jobId]?.banned ||
    data.jobs[jobId]?.account_days_left ||
    data.jobs[jobId]?.playtime_required?.time_left;

  return (
    <Box
      key={jobId}
      width="100%"
      height="42px"
      onClick={() => setSelectedJob(jobId)}
      style={{ cursor: 'pointer', userSelect: 'none' }}
      backgroundColor={selectedJob === jobId ? '#e0e26842' : ''}
    >
      <Stack>
        <Stack.Item mt="3px" ml="3px">
          <Box
            width="36px"
            height="36px"
            style={{
              boxShadow: job.sub_department
                ? `inset 3px 3px ${serverData.jobs.departments[job.sub_department].color}, inset -2px -2px ${serverData.jobs.departments[job.sub_department].color}`
                : '',
            }}
            backgroundColor={serverData.jobs.departments[job.department].color}
            position="relative"
          >
            <Box
              position="absolute"
              left="4px"
              top="4px"
              overflow="hidden"
              width="32px"
              height="32px"
            >
              <Box
                mt="28px"
                className={`preferences32x32 job___${job.css_class}`}
                style={{ transform: 'scale(3)' }}
              />
            </Box>
          </Box>
        </Stack.Item>
        <Stack.Item mt="6px">
          <Stack vertical>
            <Stack.Item>
              {data.character_preferences.misc.alternate_titles[jobId] ||
                job.display_title}
            </Stack.Item>
            <Stack.Item mt="4px">
              <Stack>
                <PriorityButton
                  color="grey"
                  name="No priority"
                  enabled={!priorities[jobId]}
                  modifier={cantPlay ? 'off' : ''}
                  onClick={() => {
                    setJobPriority(jobId);
                  }}
                />
                <PriorityButton
                  color="orange"
                  name="Low priority"
                  enabled={priorities[jobId] === 1}
                  modifier={cantPlay ? 'off' : ''}
                  onClick={() => {
                    setJobPriority(jobId, 1);
                  }}
                />
                <PriorityButton
                  color="yellow"
                  name="Medium priority"
                  enabled={priorities[jobId] === 2}
                  modifier={cantPlay ? 'off' : ''}
                  onClick={() => {
                    setJobPriority(jobId, 2);
                  }}
                />
                <PriorityButton
                  color="green"
                  name="High priority (limit of 1)"
                  enabled={priorities[jobId] === 3}
                  modifier={cantPlay ? 'off' : ''}
                  onClick={() => {
                    setJobPriority(jobId, 3);
                  }}
                />
              </Stack>
            </Stack.Item>
          </Stack>
        </Stack.Item>
      </Stack>
    </Box>
  );
};
