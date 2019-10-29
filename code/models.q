// Function needs to be split into sub functions one that does the prediction and a separate one to do the plotting
// Can wrap up both functionalities in another function but it's difficult to parse out what's happening
pr_curve:{[xtst;ytst;classifiers]
  plts:{[xtst;ytst;clf;clf_nm]
    yvals:scoring[xtst;ytst;clf;clf_nm];
    plotting[ytst;yvals;clf_nm];
    yvals 1}[xtst;ytst;classifiers]each key classifiers;
  `plt`model!(plt[`:show][];plts)
  }

// Utils
scoring:{[xtst;ytst;clf;clf_nm]
  mdl:clf[clf_nm];
  ypredict:mdl[`:predict][xtst]`;
  yscores:(mdl[`:predict_proba][xtst]`)[;1];
  conf:.ml.confdict[ytst;ypredict;1b];
  meanclassavg:avg (conf[`tp]%(sum conf[`tp`fn]);conf[`tn]%(sum conf[`tn`fp]));
  print "\n","Accuracy for ",string[clf_nm],": ",string[.ml.accuracy[ypredict;ytst]],"\n\n";
  print "Meanclass accuracy for ",string[clf_nm],": ",string[meanclassavg],"\n\n";
  show .ml.classreport[ypredict;ytst];
  (yscores;ypredict)
  }

plotting:{[ytst;scores;clf_nm]
  prt:precision_recall_curve[ytst;scores 0]`;
  average_precision:average_precision_score[ytst;scores 0]`;
  arg_dict:`linewidth`label!(3;string[clf_nm],"=",string[average_precision]);
  plt[`:plot][prt[1];prt[0];pykwargs arg_dict];
  plt[`:xlabel][`Recall;`fontsize pykw 14];
  plt[`:ylabel][`Precision;`fontsize pykw 14];
  plt[`:ylim][0.0; 1.05];
  plt[`:xlim][0.0; 1.0];
  plt[`:legend][`loc pykw "upper right";`fontsize pykw 11];
  plt[`:tight_layout][];
  }
