// Category Cards Count
const xxlCategoryCard = 6;
const xlCategoryCard = 5;
const lgCategoryCard = 5;
const baseCategoryCard = 5;
const mdCategoryCard = 5;
const smCategoryCard = 4;
const xsCategoryCard = 3;
const xxsCategoryCard = 2;

int getCategoryCardCount(double w) {
  if (w >= 1576) return xxlCategoryCard;
  if (w >= 1440) return xlCategoryCard;
  if (w >= 1280) return lgCategoryCard;
  if (w >= 1024) return baseCategoryCard;
  if (w >= 890) return mdCategoryCard;
  if (w >= 768) return smCategoryCard;
  if (w >= 480) return xsCategoryCard;
  return xxsCategoryCard;
}
