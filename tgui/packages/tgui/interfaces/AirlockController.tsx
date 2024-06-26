import { useBackend } from '../backend';
import {
  Box,
  Button,
  Dimmer,
  DmIcon,
  Flex,
  Icon,
  NoticeBox,
  Section,
  Stack,
} from '../components';
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

enum HeaterStatus {
  Off = 'off',
  Heating = 'heating',
  Cooling = 'cooling',
}

type AirlockControllerData = {
  airlockState: AirlockState;
  sensorPressure: number | string;
  sensorTemperature: number | string;
  pumpStatus: PumpStatus;
  heaterStatus: HeaterStatus;
  interiorStatus: string;
  exteriorStatus: string;
  int_door_icon: {
    icon: string;
    icon_state: string;
  } | null;
  ext_door_icon: {
    icon: string;
    icon_state: string;
  } | null;
};

export const AirlockController = () => {
  const { data } = useBackend<AirlockControllerData>();
  const { airlockState } = data;

  const statusToText = (state: AirlockState) => {
    switch (state) {
      case AirlockState.InteriorOpen:
        return { text: 'Interior Airlock Open', color: 'good' };
      case AirlockState.InteriorOpening:
        return { text: 'Cycling to Interior Airlock', color: 'average' };
      case AirlockState.Closed:
        return { text: 'Airlock Sealed', color: 'good' };
      case AirlockState.ExteriorOpening:
        return { text: 'Cycling to Exterior Airlock', color: 'average' };
      case AirlockState.ExteriorOpen:
        return { text: 'Exterior Airlock Open', color: 'good' };
      default:
        return { text: 'Unknown', color: 'bad' };
    }
  };

  const AirlockStatus = statusToText(airlockState);

  return (
    <Window width={350} height={280}>
      <Window.Content>
        <Section
          style={{ textTransform: 'capitalize', borderRadius: '4px' }}
          fill
        >
          <Stack width="100%" vertical>
            <Stack.Item textAlign="center">
              <NoticeBox
                color={AirlockStatus.color}
                style={{ borderRadius: '4px' }}
              >
                {AirlockStatus.text}
              </NoticeBox>
            </Stack.Item>
            <Stack.Item>
              <Flex>
                <Flex.Item
                  width="33%"
                  backgroundColor={'#111'}
                  mr={0.5}
                  style={{ borderRadius: '4px' }}
                >
                  <AirlockInfo />
                </Flex.Item>
                <Flex.Item
                  width="67%"
                  backgroundColor={'#111'}
                  ml={0.5}
                  style={{ borderRadius: '4px' }}
                >
                  <AirlockDisplay />
                </Flex.Item>
              </Flex>
            </Stack.Item>
            <Stack.Item>
              <Flex.Item
                width="100%"
                backgroundColor={'#111'}
                style={{ borderRadius: '4px' }}
              >
                <AirlockButtons />
              </Flex.Item>
            </Stack.Item>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};

const AirlockInfo = () => {
  const { data } = useBackend<AirlockControllerData>();

  const { sensorPressure, sensorTemperature, pumpStatus, heaterStatus } = data;
  const pressureInfo = PressureInfo(sensorPressure);
  const tempInfo = TempInfo(sensorTemperature);

  const pumpStatusToText = (status: PumpStatus) => {
    switch (status) {
      case PumpStatus.Off:
        return 'Off';
      case PumpStatus.Pressurizing:
        return 'Pressurizing';
      case PumpStatus.Depressurizing:
        return 'Depressurizing';
      default:
        return 'Unknown';
    }
  };

  const heaterStatusToText = (status: HeaterStatus) => {
    switch (status) {
      case HeaterStatus.Off:
        return 'Off';
      case HeaterStatus.Heating:
        return 'Heating';
      case HeaterStatus.Cooling:
        return 'Cooling';
      default:
        return 'Unknown';
    }
  };

  return (
    <Stack vertical ml={1} mr={1} mt={1} mb={1}>
      <Stack.Item>
        <Box style={{ textDecoration: 'underline', fontWeight: 'bold' }}>
          Temperature
        </Box>
        <Box color={tempInfo.color}>
          {sensorTemperature}K{' '}
          <Icon
            name={tempInfo.icon}
            className={tempInfo.flash ? 'alert__flash' : ''}
          />
        </Box>
      </Stack.Item>
      <Stack.Item>
        <Box style={{ textDecoration: 'underline', fontWeight: 'bold' }}>
          Regulators
        </Box>
        <Box>{heaterStatusToText(heaterStatus)}</Box>
      </Stack.Item>
      <Stack.Item>
        <Box style={{ textDecoration: 'underline', fontWeight: 'bold' }}>
          Pressure
        </Box>
        <Box color={pressureInfo.color}>
          {sensorPressure}kPa{' '}
          <Icon
            name={pressureInfo.icon}
            className={pressureInfo.flash ? 'alert__flash' : ''}
          />
        </Box>
      </Stack.Item>
      <Stack.Item>
        <Box style={{ textDecoration: 'underline', fontWeight: 'bold' }}>
          Pumps
        </Box>
        <Box>{pumpStatusToText(pumpStatus)}</Box>
      </Stack.Item>
    </Stack>
  );
};

const AirlockDisplay = () => {
  const { data } = useBackend<AirlockControllerData>();
  const { int_door_icon, ext_door_icon, airlockState } = data;

  const showDimmer = (state: AirlockState) => {
    switch (state) {
      case AirlockState.InteriorOpening:
      case AirlockState.ExteriorOpening:
        return true;
      default:
        return false;
    }
  };

  return (
    <Stack vertical ml={1} mr={1} mt={1} mb={1} fill>
      <Section fill>
        {showDimmer(airlockState) && (
          <Dimmer style={{ borderRadius: '4px' }}>
            <Stack vertical>
              <Stack.Item align="center">
                <Icon name="fan" spin size={4} />
              </Stack.Item>
              <Stack.Item>
                <Box style={{ fontFamily: 'monospace', fontSize: '16px' }}>
                  Cycling...
                </Box>
              </Stack.Item>
            </Stack>
          </Dimmer>
        )}
        <Stack.Item>
          <Box bold style={{ position: 'absolute' }} ml={4}>
            Interior
          </Box>
          <Box bold style={{ position: 'absolute' }} ml={21}>
            Exterior
          </Box>
          <DmIcon
            icon={int_door_icon.icon}
            icon_state={int_door_icon.icon_state}
            style={{ transform: 'scale(3) translateX(11px) translateY(20px)' }}
          />
          <DmIcon
            icon={ext_door_icon.icon}
            icon_state={ext_door_icon.icon_state}
            style={{ transform: 'scale(3) translateX(35px) translateY(20px)' }}
          />
        </Stack.Item>
      </Section>
    </Stack>
  );
};

const AirlockButtons = () => {
  const { act, data } = useBackend<AirlockControllerData>();
  const { airlockState } = data;

  const isCycling =
    airlockState === AirlockState.InteriorOpening ||
    airlockState === AirlockState.ExteriorOpening;
  const intOpen = airlockState === AirlockState.InteriorOpen;
  const extOpen = airlockState === AirlockState.ExteriorOpen;
  const isClosed = airlockState === AirlockState.Closed;

  return (
    <Stack ml={1} mr={1} mb={1} fill textAlign={'center'}>
      <Stack.Item mt={1} mb={1} width="35%">
        <Button
          fluid
          onClick={() => act(intOpen ? 'cycleClosed' : 'cycleInterior')}
        >
          {intOpen ? 'Close' : extOpen ? 'Cycle' : 'Open'} Interior
        </Button>
      </Stack.Item>
      <Stack.Item mt={1} mb={1} width="30%">
        <Button
          color={isCycling ? 'red' : ''}
          fluid
          disabled={isClosed}
          onClick={() => act(isCycling ? 'cycleClosed' : 'abort')}
        >
          {isCycling ? 'Abort' : 'Close'}
        </Button>
      </Stack.Item>
      <Stack.Item mt={1} mb={1} width="35%">
        <Button
          fluid
          onClick={() => act(extOpen ? 'cycleClosed' : 'cycleExterior')}
        >
          {extOpen ? 'Close' : intOpen ? 'Cycle' : 'Open'} Exterior
        </Button>
      </Stack.Item>
    </Stack>
  );
};

const PressureInfo = (pressure: number | string) => {
  if (typeof pressure === 'string') {
    return { color: 'white', icon: '' };
  }
  if (pressure <= 10) {
    return { color: 'red', icon: 'exclamation-triangle', flash: true };
  } else if (pressure <= 20) {
    return { color: 'average', icon: 'exclamation-triangle' };
  } else if (pressure >= 150) {
    return { color: 'average', icon: 'exclamation-triangle' };
  } else if (pressure >= 200) {
    return { color: 'red', icon: 'exclamation-triangle', flash: true };
  } else {
    return { color: 'white', icon: '' };
  }
};

const TempInfo = (temp: number | string) => {
  if (typeof temp === 'string') {
    return { color: 'white', icon: '' };
  }
  if (temp <= 10) {
    return { color: 'blue', icon: 'exclamation-triangle', flash: true };
  } else if (temp <= 80) {
    return { color: 'average', icon: 'exclamation-triangle' };
  } else if (temp >= 300) {
    return { color: 'average', icon: 'exclamation-triangle' };
  } else if (temp >= 400) {
    return { color: 'red', icon: 'exclamation-triangle', flash: true };
  } else {
    return { color: 'white', icon: '' };
  }
};
