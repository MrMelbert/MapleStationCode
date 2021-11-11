import { useBackend } from '../backend';
import { Button } from '../components';
import { AdvancedTraitorWindow } from './_AdvancedTraitorParts';
import { AdvancedTraitorBackgroundSection } from './_AdvancedTraitorParts';
import { AdvancedTraitorGoalsSection } from './_AdvancedTraitorParts';

export const _AdvancedHereticPanel = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    goals_finalized,
    can_ascend,
    can_sac,
  } = data;

  return (
    <AdvancedTraitorWindow theme="wizard">
      <AdvancedTraitorBackgroundSection />
      <AdvancedTraitorGoalsSection>
        <Button.Checkbox
          width="140px"
          height="20px"
          content="Toggle Ascending"
          textAlign="center"
          disabled={goals_finalized}
          checked={can_ascend}
          tooltip="Toggle the ability to ascend. \
            Disabling ascending rewards 3 bonus charges."
          onClick={() => act('toggle_ascension')} />
        <Button.Checkbox
          width="140px"
          height="20px"
          content="Toggle Sacrificing"
          textAlign="center"
          disabled={goals_finalized}
          checked={can_sac}
          tooltip="Toggle the ability to sacrifice. \
            Disabling sacrificing rewards 3 bonus charges."
          onClick={() => act('toggle_sacrificing')} />
      </AdvancedTraitorGoalsSection>
    </AdvancedTraitorWindow>
  );
};
