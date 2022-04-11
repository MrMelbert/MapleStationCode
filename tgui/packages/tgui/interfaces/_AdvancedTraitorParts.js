import { useBackend, useLocalState } from '../backend';
import { Box, Button, Divider, Input, LabeledList, Modal, NumberInput, RoundGauge, Section, Stack, Tabs, TextArea, Tooltip } from '../components';
import { Window } from '../layouts';

export const AdvancedTraitorWindow = (props, context) => {
  const {
    children,
    theme = 'maple-syndicate',
  } = props;
  return (
    <Window
      title="Antagonist Goal Panel"
      width={550}
      height={650}
      theme={theme}>
      <Window.Content>
        {children}
      </Window.Content>
    </Window>
  );
};

export const AdvancedTraitorTutorialModal = (props, context) => {
  const { act } = useBackend(context);
  return (
    <Modal>
      <Box
        mb={1}
        textAlign="center"
        preserveWhitespace >
        {props.text}
      </Box>
      <Box align="center">
        <Button
          textAlign="center"
          content="Procede"
          width="60px"
          onClick={() => act(props.tutorialAct)} />
      </Box>
    </Modal>
  );
};

export const AdvancedTraitorBackgroundSection = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    antag_type,
    backstory_tutorial_text,
  } = data;
  const { children } = props;

  return (
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
      {children
        || <AdvancedTraitorBackground employerName={props.employerName} />}
    </Section>
  );
};

export const AdvancedTraitorBackground = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    name,
    employer,
    backstory,
  } = data;
  return (
    <Stack vertical>
      <LabeledList align="center">
        <LabeledList.Item label="Title">
          <Input
            width="40%"
            value={name}
            placeholder={name}
            onInput={(e, value) => act('set_name', {
              name: value,
            })} />
        </LabeledList.Item>
        <LabeledList.Item label={props.employerName || "Employer"}>
          <Input
            width="40%"
            value={employer}
            placeholder={employer}
            onInput={(e, value) => act('set_employer', {
              employer: value,
            })} />
        </LabeledList.Item>
        <LabeledList.Divider />
        <LabeledList.Item label="Backstory">
          <TextArea
            width="66%"
            height="54px"
            value={backstory}
            placeholder={backstory}
            onInput={(e, value) => act('set_backstory', {
              backstory: value,
            })} />
        </LabeledList.Item>
      </LabeledList>
    </Stack>
  );
};

export const AdvancedTraitorGoalsSection = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    antag_type,
    objective_tutorial_text,
    finalize_text,
    goals_finalized,
    goals = [],
  } = data;
  const { children } = props;

  return (
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
      {children}
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
        <AdvancedTraitorGoals />
      )}
    </Section>
  );
};

export const AdvancedTraitorGoals = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    goals = [],
  } = data;

  const [
    selectedGoalID,
    setSelectedGoal,
  ] = useLocalState(context, 'goals', goals[0]?.id);

  const selectedGoal = goals.find(goal => {
    return goal.id === selectedGoalID;
  });

  return (
    <Stack vertical grow>
      <Divider />
      { goals.length > 0 && (
        <Stack.Item>
          <Tabs fill>
            {goals.map(goal => (
              <Tabs.Tab
                width="20%"
                key={goal.id}
                selected={goal.id === selectedGoalID}
                onClick={() => setSelectedGoal(goal.id)}>
                <Stack align="center">
                  <Stack.Item width="80%">
                    Goal: {goal.id}
                  </Stack.Item>
                  <Stack.Item width="20%">
                    <Button
                      height="90%"
                      icon="minus"
                      color="bad"
                      textAlign="center"
                      tooltip="Remove goal"
                      onClick={() => act('remove_advanced_goal', {
                        goal_ref: goal.ref })}
                    />
                  </Stack.Item>
                </Stack>
              </Tabs.Tab>
            ))}
          </Tabs>
        </Stack.Item>
      )}
      { selectedGoal ? (
        <Stack.Item>
          <Stack vertical>
            <Stack.Item>
              <Stack width="100%">
                <Stack.Item mr={3}>
                  <Stack vertical width="225px">
                    <Stack.Item >
                      Goal Text
                    </Stack.Item>
                    <Stack.Item>
                      <TextArea
                        fluid
                        height="85px"
                        value={selectedGoal.goal}
                        onInput={(e, value) => act('set_goal_text', {
                          goal_ref: selectedGoal.ref,
                          newgoal: value,
                        })} />
                    </Stack.Item>
                  </Stack>
                </Stack.Item>
                <Stack.Item mr={3}>
                  <Stack vertical align="center">
                    <Stack.Item mb={2}>
                      Intensity
                    </Stack.Item>
                    <Stack.Item mb={2}>
                      <Tooltip
                        content="Set your goal's intensity level. Check the \
                          tutorial details/examples about each level." >
                        <RoundGauge
                          size={2}
                          value={selectedGoal.intensity}
                          minValue={1}
                          maxValue={5}
                          alertAfter={3.9}
                          format={value => null}
                          position="relative"
                          ranges={{
                            "green": [1, 1.8],
                            "good": [1.8, 2.6],
                            "yellow": [2.6, 3.4],
                            "orange": [3.4, 4.2],
                            "red": [4.2, 5] }} />
                      </Tooltip>
                    </Stack.Item>
                    <Stack.Item>
                      <NumberInput
                        value={selectedGoal.intensity}
                        step={1}
                        minValue={1}
                        maxValue={5}
                        stepPixelSize={15}
                        onDrag={(e, value) => act('set_goal_intensity', {
                          goal_ref: selectedGoal.ref,
                          newlevel: value,
                        })} />
                    </Stack.Item>
                  </Stack>
                </Stack.Item>
                <Stack.Item>
                  <Stack vertical width="175px">
                    <Stack.Item>
                      Additional Notes
                    </Stack.Item>
                    <Stack.Item>
                      <TextArea
                        height="85px"
                        value={selectedGoal.notes}
                        onInput={(e, value) => act('set_note_text', {
                          goal_ref: selectedGoal.ref,
                          newtext: value,
                        })} />
                    </Stack.Item>
                  </Stack>
                </Stack.Item>
              </Stack>
            </Stack.Item>
            <Stack.Item>
              <Stack vertical fill>
                <Stack.Item>
                  <Box>
                    Similar Objectives:
                    <Button.Checkbox
                      ml={1}
                      content="Check All"
                      width="85px"
                      height="20px"
                      tooltip={selectedGoal.check_all_objectives
                        ? ("Currently, success is determined on all \
                          objectives succeeding.")
                        : ("Currently, success is determined \
                          on any one of the objectives succeeding.")}
                      checked={selectedGoal.check_all_objectives}
                      onClick={() => act('toggle_check_all_objectives', {
                        goal_ref: selectedGoal.ref })} />
                    <Button.Checkbox
                      content="Always Succeed"
                      width="130px"
                      height="20px"
                      tooltip={selectedGoal.always_succeed
                        ? ("Currently, this objective will always be marked \
                          as a success, even if no objectives are set.")
                        : ("Currently, success of this objective will depend \
                        on success of the objectives below. If no objectives \
                        are set, no success or failure text will \
                        be displayed at all.")}
                      checked={selectedGoal.always_succeed}
                      onClick={() => act('toggle_always_succeed', {
                        goal_ref: selectedGoal.ref })} />
                  </Box>
                </Stack.Item>
                <Stack.Item>
                  <Button
                    width="160px"
                    height="20px"
                    icon="plus"
                    content="Add Similar Objective"
                    textAlign="center"
                    onClick={() => act('add_similar_objective', {
                      goal_ref: selectedGoal.ref })} />
                  <Button.Confirm
                    width="210px"
                    height="20px"
                    icon="minus"
                    content="Remove All Similar Objectives"
                    disabled={!selectedGoal.objective_data.length}
                    color="bad"
                    textAlign="center"
                    onClick={() => act('clear_sim_objectives', {
                      goal_ref: selectedGoal.ref })} />
                </Stack.Item>
                <Stack.Item>
                  <Stack vertical>
                    {selectedGoal.objective_data.map(objective => (
                      <Stack.Item key={objective.trimmed_text}>
                        <Stack>
                          <Button
                            content="Remove Objective"
                            color="bad"
                            onClick={() => act('remove_similar_objective', {
                              goal_ref: selectedGoal.ref,
                              objective_ref: objective.ref })} />
                          <Tooltip content={objective.text}>
                            <Box position="relative">
                              : {objective.trimmed_text}
                            </Box>
                          </Tooltip>
                        </Stack>
                      </Stack.Item>))}
                  </Stack>
                </Stack.Item>
              </Stack>
            </Stack.Item>
          </Stack>
        </Stack.Item>
      ) : (
        <Stack.Item>
          No goals selected.
        </Stack.Item>
      )}
    </Stack>
  );
};
