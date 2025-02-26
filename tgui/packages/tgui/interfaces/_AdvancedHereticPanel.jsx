import { Button } from 'tgui-core/components';

import { useBackend } from '../backend';
import {
  AdvancedTraitorBackgroundSection,
  AdvancedTraitorGoalsSection,
  AdvancedTraitorWindow,
} from './_AdvancedTraitorParts';

export const _AdvancedHereticPanel = (props, context) => {
  const { act, data } = useBackend();
  const { goals_finalized, can_ascend, can_sac } = data;

  return (
    <AdvancedTraitorWindow theme="wizard">
      <AdvancedTraitorBackgroundSection employerName="Deity" />
      <AdvancedTraitorGoalsSection>
        <Button.Checkbox
          width="140px"
          height="20px"
          content="Toggle Ascending"
          textAlign="center"
          disabled={goals_finalized}
          checked={can_ascend}
          tooltip="Toggle the ability to ascend. \
            Disabling ascending rewards 2 bonus knowledge points."
          onClick={() => act('toggle_ascension')}
        />
      </AdvancedTraitorGoalsSection>
    </AdvancedTraitorWindow>
  );
};
