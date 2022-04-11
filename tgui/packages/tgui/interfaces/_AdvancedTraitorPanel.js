import { AdvancedTraitorWindow } from './_AdvancedTraitorParts';
import { AdvancedTraitorBackgroundSection } from './_AdvancedTraitorParts';
import { AdvancedTraitorGoalsSection } from './_AdvancedTraitorParts';

export const _AdvancedTraitorPanel = () => {
  return (
    <AdvancedTraitorWindow theme="maple-syndicate">
      <AdvancedTraitorBackgroundSection />
      <AdvancedTraitorGoalsSection />
    </AdvancedTraitorWindow>
  );
};
