var AnalyticsBehavior = AnalyticsBehavior || {};
AnalyticsBehavior.track = function() {
  if (window && window.ga) {
    return ga.apply(this, arguments);
  }
  return null;
};
