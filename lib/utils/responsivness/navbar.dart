// Navbar Image and Menu Flex
const xxlNavbarImageAndMenuFlex = 1;
const xlNavbarImageAndMenuFlex = 1;
const lgNavbarImageAndMenuFlex = 2;
const baseNavbarImageAndMenuFlex = 2;
const mdNavbarImageAndMenuFlex = 2;
const smNavbarImageAndMenuFlex = 2;
const xsNavbarImageAndMenuFlex = 2;
const xxsNavbarImageAndMenuFlex = 2;

int getNavbarImageAndMenuFlex(double w) {
  if (w >= 1576) return xxlNavbarImageAndMenuFlex;
  if (w >= 1440) return xlNavbarImageAndMenuFlex;
  if (w >= 1280) return lgNavbarImageAndMenuFlex;
  if (w >= 1024) return baseNavbarImageAndMenuFlex;
  if (w >= 890) return mdNavbarImageAndMenuFlex;
  if (w >= 768) return smNavbarImageAndMenuFlex;
  if (w >= 480) return xsNavbarImageAndMenuFlex;
  return xxsNavbarImageAndMenuFlex;
}

// Navbar Search Flex
const xxlNavbarSearchFlex = 2;
const xlNavbarSearchFlex = 2;
const lgNavbarSearchFlex = 1;
const baseNavbarSearchFlex = 1;
const mdNavbarSearchFlex = 1;
const smNavbarSearchFlex = 1;
const xsNavbarSearchFlex = 1;
const xxsNavbarSearchFlex = 1;

int getNavbarSearchFlex(double w) {
  if (w >= 1576) return xxlNavbarSearchFlex;
  if (w >= 1440) return xlNavbarSearchFlex;
  if (w >= 1280) return lgNavbarSearchFlex;
  if (w >= 1024) return baseNavbarSearchFlex;
  if (w >= 890) return mdNavbarSearchFlex;
  if (w >= 768) return smNavbarSearchFlex;
  if (w >= 480) return xsNavbarSearchFlex;
  return xxsNavbarSearchFlex;
}
