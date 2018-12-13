var AnalyticsBehavior = AnalyticsBehavior || {};
AnalyticsBehavior.track = function() {
  return ga.apply(this, arguments);
};
