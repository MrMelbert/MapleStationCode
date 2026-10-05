import {
  Box,
  Button,
  LabeledList,
  NoticeBox,
  ProgressBar,
  Section,
  Stack,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import { useBackend } from '../backend';
import { Window } from '../layouts';

type typePath = string;

type Chem = {
  id: typePath;
  name: string;
  allowed: boolean;
  volume: number;
};

type Occupant = {
  reagents: Chem[];
};

type PodData = {
  open: BooleanLike;
  occupied: BooleanLike;
  chems: Chem[];
  occupant: Occupant | null;
  metabolize_medicines_in_stasis: BooleanLike;
};

const InjectButtons = (props: { chem: Chem }) => {
  const { act, data } = useBackend<PodData>();
  const { occupied } = data;
  const chem = props.chem;

  return [5, 10].map((amount) => (
    <Button
      key={amount}
      icon="syringe"
      disabled={!occupied || !chem.allowed || chem.volume < amount}
      content={amount}
      onClick={() =>
        act('inject', {
          chem: chem.id,
          amount: amount,
        })
      }
    />
  ));
};

export const _StasisPod = (props) => {
  const { act, data } = useBackend<PodData>();
  const { chems, open, occupied, occupant, metabolize_medicines_in_stasis } =
    data;

  return (
    <Window width={450} height={350} theme="operating_computer">
      <Window.Content>
        <Section title="Medicines" scrollable>
          <Stack height="100px">
            {chems.length !== 0 ? (
              <Stack.Item>
                <LabeledList>
                  {chems.map((chem) => (
                    <LabeledList.Item
                      key={chem.name}
                      label={chem.name + ' (' + chem.volume + 'u)'}
                    >
                      <Button
                        icon="syringe"
                        content="All"
                        disabled={
                          !occupied || !chem.allowed || chem.volume > 10
                        }
                        onClick={() =>
                          act('inject', { chem: chem.id, amount: chem.volume })
                        }
                      />
                      <InjectButtons chem={chem} />
                      <Button.Confirm
                        icon="trash"
                        confirmContent={'Confirm?'}
                        confirmIcon="trash"
                        onClick={() => act('purge', { chem: chem.id })}
                      >
                        Purge
                      </Button.Confirm>
                    </LabeledList.Item>
                  ))}
                </LabeledList>
              </Stack.Item>
            ) : (
              <Stack.Item width="100%">
                <NoticeBox textAlign="center">Internal beaker empty.</NoticeBox>
              </Stack.Item>
            )}
          </Stack>
        </Section>
        <Section
          title="Patient Readout"
          scrollable
          buttons={
            <>
              <Button.Checkbox
                checked={metabolize_medicines_in_stasis}
                content="Medicine Drip"
                tooltip="While checked, the patient's body will continue
                  to metabolize medicines despite otherwise being in stasis."
                onClick={() => act('toggle_medicine_metab')}
              />
              <Button
                icon={open ? 'door-open' : 'door-closed'}
                content={open ? 'Open' : 'Closed'}
                onClick={() => act('door')}
              />
            </>
          }
        >
          <Stack height="100px">
            {occupant && occupant.reagents?.length !== 0 ? (
              <Stack.Item width="100%">
                <Stack vertical>
                  {occupant.reagents.map((reagent) => (
                    <Stack.Item key={reagent.name}>
                      <ProgressBar
                        textAlign="center"
                        value={reagent.volume}
                        minValue={0}
                        maxValue={25}
                        ranges={{
                          good: [0, 20],
                          average: [20, 25],
                          bad: [25, Infinity],
                        }}
                      >
                        <Box textAlign="center">
                          {`${reagent.name} (${reagent.volume}u)`}
                        </Box>
                      </ProgressBar>
                    </Stack.Item>
                  ))}
                </Stack>
              </Stack.Item>
            ) : (
              <Stack.Item width="100%">
                <NoticeBox textAlign="center" color={occupant ? 'green' : null}>
                  {occupant
                    ? 'Patient has no chemicals detected.'
                    : 'No patient detected.'}
                </NoticeBox>
              </Stack.Item>
            )}
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};
