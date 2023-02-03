// Containers
const xxlContainer = 250.0;
const xlContainer = 150.0;
const lgContainer = 125.0;
const baseContainer = 75.0;
const mdContainer = 5.0;
const smContainer = 5.0;
const xsContainer = 5.0;
const xxsContainer = 5.0;

double getContainerSize(double w){
  if(w >= 1576) return xxlContainer;
  if(w >= 1440) return xlContainer;
  if(w >= 1280) return lgContainer;
  if(w >= 1024) return baseContainer;
  if(w >= 890) return mdContainer;
  if(w >= 768) return smContainer;
  if(w >= 480) return xsContainer;
  return xxsContainer;
}