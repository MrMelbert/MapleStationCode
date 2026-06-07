import {
  AnimatedNumber,
  Blink,
  Button,
  Dimmer,
  Icon,
  LabeledList,
  NoticeBox,
  NumberInput,
  ProgressBar,
  Section,
  Stack,
} from 'tgui-core/components';
import { capitalizeAll, capitalizeFirst } from 'tgui-core/string';
import { useBackend, useSharedState } from '../../backend';
import { type BodyZone, BodyZoneSelector } from '../common/BodyZoneSelector';
import { extractSurgeryName } from './helpers';
import {
  ComputerTabs,
  damageTypes,
  type OperatingComputerData,
  type PatientData,
} from './types';

type PatientStateViewProps = {
  setTab: (tab: number) => void;
  setSearchText: (text: string) => void;
  pinnedOperations: string[];
  setPinnedOperations: (text: string[]) => void;
};
export const PatientStateView = (props: PatientStateViewProps) => {
  const { data } = useBackend<OperatingComputerData>();
  const { setTab, setSearchText, pinnedOperations, setPinnedOperations } =
    props;

  const { has_table, patient } = data;
  if (!has_table) {
    return (
      <Section fill>
        <NoticeBox color="yellow" align="center">
          No table detected
        </NoticeBox>
      </Section>
    );
  }
  if (!patient) {
    return (
      <Section fill>
        <NoticeBox color="red" align="center">
          No patient detected
        </NoticeBox>
      </Section>
    );
  }
  return (
    <Section fill>
      <Stack vertical fill>
        <Stack.Item>
          <PatientStateMainStateView patient={patient} />
        </Stack.Item>
        <Stack.Item p={1}>
          <PatientStateSurgeryStateView
            patient={patient}
            target_zone={data.target_zone}
          />
        </Stack.Item>
        {/* NON-MODULE CHANGE START */}
        <Stack.Item>
          <PatientStateAnesthesiaView />
        </Stack.Item>
        {/* NON-MODULE CHANGE END */}
        <Stack.Item grow>
          <PatientStateNextOperationsView
            pinnedOperations={pinnedOperations}
            setPinnedOperations={setPinnedOperations}
            setTab={setTab}
            setSearchText={setSearchText}
          />
        </Stack.Item>
      </Stack>
    </Section>
  );
};

type PatientStateMainStateViewProps = {
  patient: PatientData;
};

// NON-MODULE CHANGE
// damage will often have floating point errors from dm so we truncate to 2 sigfics
function truncateDamage(value: number): number {
  return Math.round(value * 100) / 100;
}

const PatientStateMainStateView = (props: PatientStateMainStateViewProps) => {
  const { patient } = props;

  return (
    <LabeledList>
      {/* NON-MODULE CHANGE START */}
      <LabeledList.Item label="State">
        <Stack>
          <Stack.Item color={patient.statstate}>{patient.stat}</Stack.Item>
          <Stack.Divider />
          <Stack.Item color={patient.heartratestate}>
            {patient.heartrate} bpm
          </Stack.Item>
        </Stack>
      </LabeledList.Item>
      <LabeledList.Item label="Health">
        <ProgressBar
          value={patient.health}
          minValue={patient.minHealth}
          maxValue={patient.maxHealth}
          color={patient.health >= 0 ? 'good' : 'average'}
        >
          <AnimatedNumber
            value={patient.health}
            format={(value) => `${truncateDamage(value)}%`}
          />
        </ProgressBar>
      </LabeledList.Item>
      <LabeledList.Item label="Blood Level">
        <ProgressBar
          align="right"
          value={patient.blood_level}
          minValue={0}
          maxValue={patient.standard_blood_level}
          color={
            patient.blood_level >= patient.standard_blood_level * 0.7
              ? 'good'
              : patient.blood_level >= patient.standard_blood_level * 0.45
                ? 'average'
                : 'bad'
          }
        >
          <Stack>
            <Stack.Item>
              Type: <b>{patient.blood_type || 'Unknown'}</b>
            </Stack.Item>
            <Stack.Item grow>
              <AnimatedNumber
                value={patient.blood_level / patient.standard_blood_level}
                format={(value) => `${truncateDamage(value * 100)}%`}
              />
            </Stack.Item>
          </Stack>
        </ProgressBar>
      </LabeledList.Item>
      {damageTypes.map((type) => (
        <LabeledList.Item key={type.type} label={type.label}>
          <ProgressBar
            value={patient[type.type] / patient.maxHealth}
            color="bad"
          >
            <AnimatedNumber value={truncateDamage(patient[type.type])} />
          </ProgressBar>
        </LabeledList.Item>
      ))}
      {/* NON-MODULE CHANGE END */}
    </LabeledList>
  );
};

type PatientStateSurgeryStateViewProps = {
  patient: PatientData;
  target_zone: BodyZone;
};

const PatientStateSurgeryStateView = (
  props: PatientStateSurgeryStateViewProps,
) => {
  const { act, data } = useBackend<OperatingComputerData>();
  const { patient, target_zone } = props;

  return (
    <Stack>
      <Stack.Item>
        <BodyZoneSelector
          theme="slimecore"
          onClick={(zone) =>
            zone !== target_zone && act('change_zone', { new_zone: zone })
          }
          selectedZone={target_zone}
        />
      </Stack.Item>
      <Stack.Item>
        <Stack vertical>
          {patient.surgery_state.map((state) => (
            <Stack.Item key={state}>- {state}</Stack.Item>
          ))}
        </Stack>
      </Stack.Item>
    </Stack>
  );
};

type PatientStateNextOperationsViewProps = {
  pinnedOperations: string[];
  setPinnedOperations: (text: string[]) => void;
  setTab: (tab: number) => void;
  setSearchText: (text: string) => void;
};

const PatientStateNextOperationsView = (
  props: PatientStateNextOperationsViewProps,
) => {
  const { data } = useBackend<OperatingComputerData>();
  const { surgeries } = data;
  const { pinnedOperations, setPinnedOperations, setTab, setSearchText } =
    props;

  const possible_next_operations = surgeries.filter(
    (operation) => operation.show_as_next,
  );

  const allTools = ['all tools'].concat(
    possible_next_operations
      .map((operation) => operation.tool_rec)
      .flatMap((tool) => tool.split(' / '))
      .filter((tools, index, self) => self.indexOf(tools) === index),
  );

  const [filterByTool, setFilterByTool] = useSharedState<string>(
    'filter_by_tool',
    allTools[0],
  );

  if (pinnedOperations.length > 0) {
    possible_next_operations.sort((a, b) => {
      if (
        pinnedOperations.includes(a.name) &&
        !pinnedOperations.includes(b.name)
      ) {
        return -1;
      }
      if (
        !pinnedOperations.includes(a.name) &&
        pinnedOperations.includes(b.name)
      ) {
        return 1;
      }
      return 0;
    });
  }

  possible_next_operations.sort((a, b) => (a.priority && !b.priority ? -1 : 1));

  return (
    <Section
      title="Possible Operations"
      scrollable
      fill
      buttons={
        <Button
          icon="filter"
          tooltip="Filter by recommended tool. Right click to reset."
          tooltipPosition="top"
          width="100px"
          ellipsis
          selected={filterByTool !== allTools[0]}
          onClick={() =>
            setFilterByTool(
              allTools[(allTools.indexOf(filterByTool) + 1) % allTools.length],
            )
          }
          onContextMenu={() => setFilterByTool(allTools[0])}
        >
          {capitalizeFirst(filterByTool)}
        </Button>
      }
    >
      <Stack vertical fill>
        {possible_next_operations.length === 0 ? (
          <Stack.Item>
            <NoticeBox color="green" align="center">
              No operations available
            </NoticeBox>
          </Stack.Item>
        ) : (
          possible_next_operations
            .filter(
              (operation) =>
                filterByTool === allTools[0] ||
                operation.tool_rec.includes(filterByTool),
            )
            .map((operation) => {
              const { name, tool } = extractSurgeryName(operation, false);
              return (
                <Stack.Item key={operation.name}>
                  <Button
                    fluid
                    tooltip={
                      <Stack vertical>
                        {!!operation.priority && (
                          <Stack.Item color="orange">
                            <Icon name="exclamation" mr={1} />
                            Recommended next step
                          </Stack.Item>
                        )}
                        {pinnedOperations.includes(operation.name) && (
                          <Stack.Item color="yellow">
                            <Icon name="thumbtack" mr={1} />
                            Pinned
                          </Stack.Item>
                        )}
                        <Stack.Item>{operation.desc}</Stack.Item>
                        <Stack.Item italic fontSize="0.9rem">
                          {`Left click ${
                            pinnedOperations.includes(operation.name)
                              ? 'unpins operation from'
                              : 'pins operation to'
                          } the top.`}
                        </Stack.Item>
                        {!!operation.show_in_list && (
                          <Stack.Item italic fontSize="0.9rem">
                            Right click opens operation info.
                          </Stack.Item>
                        )}
                      </Stack>
                    }
                    tooltipPosition="bottom"
                    color={
                      operation.priority
                        ? 'caution'
                        : pinnedOperations.includes(operation.name)
                          ? 'danger'
                          : undefined
                    }
                    onContextMenu={() => {
                      if (operation.show_in_list) {
                        setTab(ComputerTabs.OperationCatalog);
                        setSearchText(operation.name);
                      }
                    }}
                    onClick={() => {
                      setPinnedOperations(
                        pinnedOperations.includes(operation.name)
                          ? pinnedOperations.filter(
                              (op) => op !== operation.name,
                            )
                          : pinnedOperations.concat(operation.name),
                      );
                    }}
                  >
                    <Stack fill>
                      <Stack.Item
                        style={{
                          textOverflow: 'ellipsis',
                          overflow: 'hidden',
                        }}
                      >
                        {name}
                      </Stack.Item>
                      {!!operation.priority && (
                        <Stack.Item>
                          <Blink interval={500} time={500}>
                            <Icon name="exclamation" />
                          </Blink>
                        </Stack.Item>
                      )}
                      {pinnedOperations.includes(operation.name) && (
                        <Stack.Item>
                          <Icon name="thumbtack" />
                        </Stack.Item>
                      )}
                      <Stack.Item grow />
                      <Stack.Item italic fontSize="0.9rem">
                        {capitalizeAll(tool)}
                      </Stack.Item>
                    </Stack>
                  </Button>
                </Stack.Item>
              );
            })
        )}
      </Stack>
    </Section>
  );
};

// NON-MODULE CHANGE
const PatientStateAnesthesiaView = () => {
  const { act, data } = useBackend<OperatingComputerData>();
  const { anesthesia } = data;
  if (!anesthesia) return null;

  const failsafe_enabled = anesthesia.failsafe !== -1;

  return (
    <Section title="Anesthesia Control">
      {!anesthesia.has_tank && <Dimmer>No anesthesia tank attached.</Dimmer>}
      <Stack fill>
        <Stack.Item width="50%" textAlign="right">
          <Button.Checkbox
            width="60%"
            align="center"
            // Open is FALSE if we have no tank, likewise for can_open_tank
            disabled={!anesthesia.open && !anesthesia.can_open_tank}
            color={anesthesia.open ? 'bad' : 'good'}
            icon="fan"
            onClick={() => act('toggle_anesthesia')}
          >
            {anesthesia.open ? 'Close Tank' : 'Open Tank'}
          </Button.Checkbox>
        </Stack.Item>
        <Stack.Divider />
        <Stack.Item width="50%">
          <Stack fill align="center">
            <Stack.Item>
              <Button
                color={failsafe_enabled ? 'good' : 'caution'}
                icon={failsafe_enabled ? 'square-check-o' : 'square-o'}
                tooltip={
                  failsafe_enabled
                    ? 'Automatically closes the attached tank if a set amount of time has elapsed.'
                    : ''
                }
                onClick={() =>
                  failsafe_enabled
                    ? act('disable_failsafe')
                    : act('set_failsafe', { new_failsafe_time: 360 })
                }
              >
                Safety
              </Button>
            </Stack.Item>
            <Stack.Item>
              <NumberInput
                fluid
                animated
                unit="seconds"
                width="100px"
                minValue={5}
                maxValue={600}
                step={1}
                value={failsafe_enabled ? anesthesia.failsafe : 0}
                disabled={!failsafe_enabled} // Just in case
                onChange={(value) =>
                  act('set_failsafe', { new_failsafe_time: value })
                }
              />
            </Stack.Item>
          </Stack>
        </Stack.Item>
      </Stack>
    </Section>
  );
};
