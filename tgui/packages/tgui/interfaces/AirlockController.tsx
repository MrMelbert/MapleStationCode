import { useBackend } from '../backend';
import { Box, Button, Icon, LabeledList, Section } from '../components';
import { Window } from '../layouts';

enum AirlockState {
  InteriorOpen = 'inopen',
  InteriorOpening = 'inopening',
  Closed = 'closed',
  ExteriorOpening = 'exopening',
  ExteriorOpen = 'exopen',
}

enum PumpStatus {
  Off = 'off',
  Pressurizing = 'pressurizing',
  Depressurizing = 'depressurizing',
}

type AirlockControllerData = {
  airlockState: AirlockState;
  sensorPressure: number;
  pumpStatus: PumpStatus;
  interiorStatus: string;
  exteriorStatus: string;
};

type AirlockStatus = {
  primary: string;
  icon: string;
  color: string;
};

export const AirlockController = () => {
  const { data } = useBackend<AirlockControllerData>();
  const { airlockState, pumpStatus, interiorStatus, exteriorStatus } = data;

  const statusToText = (state: AirlockState) => {
    switch (state) {
      case AirlockState.InteriorOpen:
        return 'Interior Airlock Open';
      case AirlockState.InteriorOpening:
        return 'Cycling to Interior Airlock';
      case AirlockState.Closed:
        return 'Inactive';
      case AirlockState.ExteriorOpening:
        return 'Cycling to Exterior Airlock';
      case AirlockState.ExteriorOpen:
        return 'Exterior Airlock Open';
      default:
        return 'Unknown';
    }
  };

  return (
    <Window width={500} height={190}>
      <Window.Content>
        <Section
          title="Airlock Status"
          buttons={<AirLockButtons />}
          style={{ textTransform: 'capitalize' }}
        >
          <LabeledList>
            <LabeledList.Item label="Current Status">
              {statusToText(airlockState)}
            </LabeledList.Item>
            <LabeledList.Item label="Chamber Pressure">
              <PressureIndicator />
            </LabeledList.Item>
            <LabeledList.Item label="Control Pump">
              {pumpStatus}
            </LabeledList.Item>
            <LabeledList.Item label="Interior Door">
              <Box color={interiorStatus === 'open' && 'good'}>
                {interiorStatus}
              </Box>
            </LabeledList.Item>
            <LabeledList.Item label="Exterior Door">
              <Box color={exteriorStatus === 'open' && 'good'}>
                {exteriorStatus}
              </Box>
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};

/** Displays the buttons on top of the window to cycle the airlock */
const AirLockButtons = (props) => {
  const { act, data } = useBackend<AirlockControllerData>();
  const { airlockState } = data;
  switch (airlockState) {
    case AirlockState.InteriorOpening:
    case AirlockState.ExteriorOpening:
      return (
        <Button icon="stop-circle" onClick={() => act('abort')}>
          Abort
        </Button>
      );
    case AirlockState.Closed:
      return (
        <>
          <Button icon="lock-open" onClick={() => act('cycleInterior')}>
            Open Interior Airlock
          </Button>
          <Button icon="lock-open" onClick={() => act('cycleExterior')}>
            Open Exterior Airlock
          </Button>
        </>
      );
    case AirlockState.InteriorOpen:
      return (
        <>
          <Button icon="lock" onClick={() => act('cycleClosed')}>
            Close Interior Airlock
          </Button>
          <Button icon="sync" onClick={() => act('cycleExterior')}>
            Cycle to Exterior Airlock
          </Button>
        </>
      );
    case AirlockState.ExteriorOpen:
      return (
        <>
          <Button icon="lock" onClick={() => act('cycleClosed')}>
            Close Exterior Airlock
          </Button>
          <Button icon="sync" onClick={() => act('cycleInterior')}>
            Cycle to Interior Airlock
          </Button>
        </>
      );
    default:
      return null;
  }
};

/** Displays the numeric pressure alongside an icon for the user */
const PressureIndicator = () => {
  const { data } = useBackend<AirlockControllerData>();
  const { airlockState, pumpStatus, sensorPressure } = data;

  const StatusFromState = () => {
    if (
      airlockState === AirlockState.InteriorOpening ||
      airlockState === AirlockState.ExteriorOpening
    ) {
      if (sensorPressure <= 10) {
        return { color: 'red', icon: 'fan' };
      } else if (sensorPressure >= 200) {
        return { color: 'red', icon: 'fan' };
      } else {
        return { color: 'average', icon: 'fan' };
      }
    }
    if (sensorPressure <= 10) {
      return { color: 'red', icon: 'exclamation-triangle' };
    } else if (sensorPressure <= 20) {
      return { color: 'average', icon: 'exclamation-triangle' };
    } else if (sensorPressure >= 150) {
      return { color: 'average', icon: 'exclamation-triangle' };
    } else if (sensorPressure >= 200) {
      return { color: 'red', icon: 'exclamation-triangle' };
    } else {
      return { color: 'white', icon: '' };
    }
  };

  const { color, icon } = StatusFromState();
  let spin =
    icon === 'fan' &&
    (pumpStatus === PumpStatus.Pressurizing ||
      pumpStatus === PumpStatus.Depressurizing);

  return (
    <Box color={color}>
      {sensorPressure} kPa {icon && <Icon name={icon} spin={spin} />}
    </Box>
  );
};
