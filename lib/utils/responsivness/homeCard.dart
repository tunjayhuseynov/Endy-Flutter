// Home Cards Count
const xxlCardCount = 5;
const xlCardCount = 5;
const lgCard = 5;
const baseCard = 5;
const mdCard = 5;
const smCard = 4;
const xsCard = 3;
const xxsCard = 2;

int getHomeGridCardCount(double w) {
  if (w >= 1576) return xxlCardCount;
  if (w >= 1440) return xlCardCount;
  if (w >= 1280) return lgCard;
  if (w >= 1024) return baseCard;
  if (w >= 890) return mdCard;
  if (w >= 768) return smCard;
  if (w >= 480) return xsCard;
  return xxsCard;
}
