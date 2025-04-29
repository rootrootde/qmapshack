# Toggle Visibility of All Projects Feature

## 1. Added `actionToggleVisibilityAllProjects` to the UI
- **File**: `IMainWindow.ui`
- **Change**: Added a new `QAction` for toggling the visibility of all projects.

```xml
<action name="actionToggleVisibilityAllProjects">
   <property name="checkable">
    <bool>true</bool>
   </property>
   <property name="text">
    <string>Toggle Visibility of All Projects</string>
   </property>
   <property name="toolTip">
    <string>Toggle visibility of all projects in the workspace</string>
   </property>
   <property name="shortcut">
    <string>Ctrl+.</string>
   </property>
</action>
```

---

## 2. Connected `actionToggleVisibilityAllProjects` in `setExternalMenu`
- **File**: `CGisListWks.cpp`
- **Change**: Connected the `actionToggleVisibilityAllProjects` to the new slot `slotToggleVisibilityAllProjects` in the `setExternalMenu` function.

```cpp
void CGisListWks::setExternalMenu(QMenu* project) {
    menuNone = project;
    connect(CMainWindow::self().findChild<QAction*>("actionToggleVisibilityAllProjects"), &QAction::triggered, this,
            &CGisListWks::slotToggleVisibilityAllProjects);
}
```

---

## 3. Implemented `slotToggleVisibilityAllProjects`
- **File**: `CGisListWks.cpp`
- **Change**: Added the `slotToggleVisibilityAllProjects` function to toggle the visibility of all projects in the workspace. It uses the `checked` state of the `actionToggleVisibilityAllProjects` to determine whether to show or hide projects.

```cpp
void CGisListWks::slotToggleVisibilityAllProjects() {
    static QSet<IGisProject*> visibleProjects; // Tracks currently visible projects

    QAction* action = CMainWindow::self().findChild<QAction*>("actionToggleVisibilityAllProjects");
    if (!action) {
        qDebug() << "slotToggleVisibilityAllProjects triggered without a valid action.";
        return;
    }

    bool isChecked = action->isChecked();
    qDebug() << "slotToggleVisibilityAllProjects triggered. Action checked state:" << isChecked;

    // Use findItems to retrieve all projects in the workspace
    const QList<QTreeWidgetItem*>& items = findItems("*", Qt::MatchWildcard);
    for (QTreeWidgetItem* item : items) {
        IGisProject* project = dynamic_cast<IGisProject*>(item);
        if (project != nullptr) {
            if (isChecked) {
                // Show only projects that were previously visible
                if (visibleProjects.contains(project)) {
                    project->setCheckState(CGisListDB::eColumnCheckbox, Qt::Checked);
                    qDebug() << "Showing project:" << project->getName();
                }
            } else {
                // Hide only projects that are currently visible
                if (project->checkState(CGisListDB::eColumnCheckbox) == Qt::Checked) {
                    visibleProjects.insert(project);
                    project->setCheckState(CGisListDB::eColumnCheckbox, Qt::Unchecked);
                    qDebug() << "Hiding project:" << project->getName();
                }
            }
        }
    }

    if (isChecked) {
        visibleProjects.clear(); // Clear the set after restoring visibility
    }

    emit sigChanged();
    qDebug() << "Visibility toggled. Action checked state now:" << isChecked;
}
```

---

## 4. Debugging Statements
- Added `qDebug()` statements throughout the code to log the following:
  - When the `slotToggleVisibilityAllProjects` function is triggered.
  - The `checked` state of the `actionToggleVisibilityAllProjects`.
  - Which projects are being hidden or shown.

Example:
```cpp
qDebug() << "slotToggleVisibilityAllProjects triggered. Action checked state:" << isChecked;
qDebug() << "Hiding project:" << project->getName();
qDebug() << "Showing project:" << project->getName();
```

---

## 5. Used `findChild` to Retrieve the Original Action
- Instead of creating a new `QAction`, the existing `actionToggleVisibilityAllProjects` from `CMainWindow` was retrieved using `findChild`.

Example:
```cpp
QAction* action = CMainWindow::self().findChild<QAction*>("actionToggleVisibilityAllProjects");
```

---

## 6. Behavior
- **Hiding Projects**: When the action is unchecked, all currently visible projects are hidden, and their references are stored in `visibleProjects`.
- **Showing Projects**: When the action is checked, only the projects stored in `visibleProjects` are shown again.