import { Box, Section, NoticeBox } from 'tgui-core/components';
import { classes } from 'tgui-core/react';
import { GENE_COLORS } from './constants';

export const SequenceScannerChatBox = (props) => {
  const { passed_sequence, mutation_name } = props;
  const bases = [];
  for (let i = 0; i < passed_sequence.length; i++) {
    const gene = passed_sequence.charAt(i);
    const dna_base = (
      <Box width="22px" textAlign="center" backgroundColor={`${GENE_COLORS[gene]}`}>
        {gene}
      </Box>
    );
    bases.push(dna_base);
  }
  // Render genome in two rows
  const pairs = [];
  for (let i = 0; i < bases.length; i += 2) {
    const pair = (
      <Box key={i} inline m={0.5}>
        {bases[i]}
        <Box
          mt="-2px"
          ml="10px"
          width="2px"
          height="8px"
          backgroundColor="label"
        />
        {bases[i + 1]}
      </Box>
    );

    if (i % 8 === 0 && i !== 0) {
      pairs.push(
        <Box
          key={`${i}_divider`}
          inline
          position="relative"
          top="-17px"
          left="-1px"
          width="8px"
          height="2px"
          backgroundColor="label"
        />,
      );
    }

    pairs.push(pair);
  };
  return (
    <NoticeBox
      p="15px"
      backgroundColor="#4a4d5a31"
    >
      <Box fontSize="125%" p="3px" textColor="#aee0b9ff">{mutation_name}</Box>
      <Box
        backgroundColor="#4a555f69"
        fontWeight="normal"
        pl="-5px"
      >
        <center>
          <Box py="5px">
            {pairs}
          </Box>
        </center>
      </Box>
    </NoticeBox>
  )
};
