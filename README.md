# LSNRLS
Learning shared and non-redundant label-specific features for partial multi-label classification

# Abstract
  Partial multi-label learning (PML) is designed to address the challenge of having both ground-truth labels and noisy labels in the label set of training instances. In real-world applications, there are often noisy features in addition to noisy labels, but existing PML methods fail to filter out these noisy features or account for feature correlations, label correlations, and feature-label correlations together in the feature learning process. These oversights lead to poor classification accuracy, as the comprehensive exploration of feature and label information in PML can contribute significantly to disambiguation. To address this issue, we propose a novel PML framework that disambiguates candidate labels and learns label-specific features while taking into account all three types of correlations between features and labels. First, we capture high-order label correlations by employing the low-rank representation to obtain a complementary label matrix induced from the partial label matrix, which accounts for the presence of noisy labels. Then, we learn a shared and non-redundant label-specific data representation by incorporating intrinsic feature correlations and the learned label correlations to mitigate the impact of noisy features. Finally, we build a classifier by mapping the label-specific feature representation to the complementary label matrix to model the feature-label correlations. Various experiments validate the superiority of our method.


# Main contributions
1. We propose a novel PML method by integrating label disambiguation and label-specific feature learning into a unified model, which mitigates the effects of noisy features and labels in an interactive way.
2. Different from existing label-specific feature learning methods, we learn shared and non-redundant label-specific features by incorporating feature correlations, label correlations and feature-label correlations simultaneously.
3. We introduce the sparse prototype matrix which can preserve the sparse pattern of the coefficient matrix to avoid possible false discovery of label-specific features.
4. Based on the experimental results, we conclude our method is significantly superior to other partial multi-label learning methods on a series of benchmark data sets from diverse domains.
 
# Reference
 Zou Y, Hu X, Li P, et al. Learning Shared and Non-Redundant Label-Specific Features for Partial Multi-Label Classification[J]. Information Sciences, 2023: 119917.

