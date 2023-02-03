// Search Cards Count
const xxlSearchCardCount = 6;
const xlSearchCardCount = 5;
const lgSearchCard = 5;
const baseSearchCard = 5;
const mdSearchCard = 5;
const smSearchCard = 4;
const xsSearchCard = 3;
const xxsSearchCard = 2;

int getSearchCardCount(double w){
  if(w >= 1576) return xxlSearchCardCount;
  if(w >= 1440) return xlSearchCardCount;
  if(w >= 1280) return lgSearchCard;
  if(w >= 1024) return baseSearchCard;
  if(w >= 890) return mdSearchCard;
  if(w >= 768) return smSearchCard;
  if(w >= 480) return xsSearchCard;
  return xxsSearchCard;
}