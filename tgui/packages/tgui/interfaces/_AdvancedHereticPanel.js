import { useBackend, useSharedState } from '../backend';
import { Button, Divider, Flex, Section } from '../components';
import { Window } from '../layouts';
import { AdvancedTraitorPanelBackground } from './_AdvancedTraitorParts';
import { AdvancedTraitorPanelGoals } from './_AdvancedTraitorParts';
import { AdvancedTraitorTutorialModal } from './_AdvancedTraitorParts';

export const _AdvancedHereticPanel = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    antag_type,
    finalize_text,
    goals_finalized,
    goals = [],
    backstory_tutorial_text,
    objective_tutorial_text,
    can_ascend,
    can_sac,
  } = data;

  return (
    <Window
      title="Antagonist Goal Panel"
      width={600}
      height={600}
      theme="wizard">
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
        <Divider />
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
          <Flex mb={1}>
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
              content="Toggle Ascending"
              textAlign="center"
              checked={can_ascend}
              tooltip="Toggle the ability to ascend. \
                      Disabling ascending rewards 3 bonus charges."
              onClick={() => act('toggle_ascension')} />
            <Button.Checkbox
              width="140px"
              height="20px"
              content="Toggle Sacrificing"
              textAlign="center"
              checked={can_sac}
              tooltip="Toggle the ability to sacrifice. \
                      Disabling sacrificing rewards 3 bonus charges."
              onClick={() => act('toggle_sacrificing')} />
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
          </Flex>
          { !!goals.length && (
            <AdvancedTraitorPanelGoals />
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};
