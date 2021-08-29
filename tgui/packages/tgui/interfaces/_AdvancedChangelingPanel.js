import { useBackend } from '../backend';
import { Button, Section } from '../components';
import { Window } from '../layouts';
import { AdvancedTraitorPanelBackground } from './_AdvancedTraitorParts';
import { AdvancedTraitorPanelGoals } from './_AdvancedTraitorParts';
import { AdvancedTraitorTutorialModal } from './_AdvancedTraitorParts';

export const _AdvancedChangelingPanel = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    antag_type,
    finalize_text,
    goals_finalized,
    goals = [],
    backstory_tutorial_text,
    objective_tutorial_text,
    cannot_absorb,
  } = data;

  return (
    <Window
      title="Antagonist Goal Panel"
      width={550}
      height={650}
      theme="neutral">
      <Window.Content>
        <Section
          title={`${ antag_type } Background`}
          buttons={(
            <Button
              content="Tutorial: Background"
              color="good"
              onClick={() => act('begin_background_tutorial')}
            />
          )}>
          { backstory_tutorial_text && (
            <AdvancedTraitorTutorialModal
              text={backstory_tutorial_text}
              tutorialAct="proceede_beginner_tutorial" />
          )}
          <AdvancedTraitorPanelBackground />
        </Section>
        <Section
          title={`${ antag_type } Objectives`}
          buttons={(
            <Button
              content="Tutorial: Objectives"
              color="good"
              onClick={() => act('begin_objective_tutorial')}
            />
          )}>
          { objective_tutorial_text && (
            <AdvancedTraitorTutorialModal
              text={objective_tutorial_text}
              tutorialAct="proceede_objective_tutorial" />
          )}
          <Button
            width="85px"
            height="20px"
            icon="plus"
            content="Add Goal"
            textAlign="center"
            onClick={() => act('add_advanced_goal')} />
          <Button.Checkbox
            width="140px"
            height="20px"
            content="Disable Absorb"
            textAlign="center"
            disabled={goals_finalized}
            checked={cannot_absorb}
            tooltip="If checked, the ability to use absorb will be disabled. \
                    Disabling absorbing rewards +10 max chemical storage."
            onClick={() => act('toggle_absorb')} />
          { goals_finalized === 0 && (
            <Button.Confirm
              width="112px"
              height="20px"
              icon="exclamation-circle"
              content="Finalize Goals"
              color="bad"
              textAlign="center"
              tooltip={finalize_text}
              onClick={() => act('finalize_goals')} />)}
          { !!goals.length && (
            <AdvancedTraitorPanelGoals />
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};
