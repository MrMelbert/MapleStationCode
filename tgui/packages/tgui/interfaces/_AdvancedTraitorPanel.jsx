import {
  AdvancedTraitorBackgroundSection,
  AdvancedTraitorGoalsSection,
  AdvancedTraitorWindow,
} from './_AdvancedTraitorParts';

export const _AdvancedTraitorPanel = () => {
  return (
    <AdvancedTraitorWindow theme="syndicate">
      <AdvancedTraitorBackgroundSection />
      <AdvancedTraitorGoalsSection />
    </AdvancedTraitorWindow>
  );
};
