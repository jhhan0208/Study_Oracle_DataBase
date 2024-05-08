 1. Zlotkey와 동일한 부서에 속한 모든 사원의 이름과 입사일을 표시하는 질의를 작성하십시오. (Zlotkey는 제외)

SELECT E.LAST_NAME, E.HIRE_DATE
FROM EMPLOYEES E
WHERE E.DEPARTMENT_ID = (SELECT DEPARTMENT_ID FROM EMPLOYEES WHERE LAST_NAME = 'Zlotkey')
AND E.LAST_NAME != 'Zlotkey'

- 부질의 없이: 

SELECT a.LAST_NAME, a.HIRE_DATE
FROM EMPLOYEES a, EMPLOYEES b
WHERE a.DEPARTMENT_ID = b.DEPARTMENT_ID
AND b.LAST_NAME = 'Zlotkey'
AND a.LAST_NAME != 'Zlotkey'

 2. 급여가 평균 급여보다 많은 모든 사원의 사원 번호와 이름을 표시하는 질의를 작성하고 결과를 급여에 대해 오름차순으로 정렬하십시오.

SELECT E.EMPLOYEE_ID, E.LAST_NAME, E.SALARY
FROM EMPLOYEES E
WHERE E.SALARY > (SELECT AVG(SALARY) FROM EMPLOYEES)
ORDER BY E.SALARY

- 부질의 없이: 
SELECT a.EMPLOYEE_ID, a.LAST_NAME
FROM EMPLOYEES a, EMPLOYEES b
GROUP BY a.EMPLOYEE_ID, a.LAST_NAME, a.SALARY
HAVING a.SALARY > AVG(b.SALARY)

 3. 이름에 u가 포함된 사원과 같은 부서에서 일하는 모든 사원의 사원번호와 이름을 표시하는 질의를 작성하십시오.

SELECT E.EMPLOYEE_ID, E.LAST_NAME
FROM EMPLOYEES E
WHERE E.DEPARTMENT_ID in (SELECT DEPARTMENT_ID FROM EMPLOYEES WHERE LAST_NAME like '%u%')

 4. 부서 위치 ID가 1700인 모든 사원의 이름, 부서 번호 및 업무 ID를 표시하십시오.

SELECT E.LAST_NAME, E.DEPARTMENT_ID, E.JOB_ID
FROM EMPLOYEES E
WHERE E.DEPARTMENT_ID in (SELECT DEPARTMENT_ID FROM DEPARTMENTS WHERE LOCATION_ID = '1700')

부질의 없이:

SELECT E.LAST_NAME, E.DEPARTMENT_ID, E.JOB_ID
FROM EMPLOYEES E, DEPARTMENTS D
WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID
AND D.LOCATION_ID = '1700'

 5. King에게 보고하는 모든 사원 이름과 급여를 표시하십시오.

SELECT E.LAST_NAME, E.SALARY
FROM EMPLOYEES E
WHERE E.MANAGER_ID in (SELECT EMPLOYEE_ID FROM EMPLOYEES WHERE LAST_NAME = 'King')
AND E.LAST_NAME != 'King'

 6. Executive 부서의 모든 사원에 대한 부서 번호, 이름 및 업무 ID를 표시하십시오.

SELECT E.DEPARTMENT_ID, E.LAST_NAME, E.JOB_ID
FROM EMPLOYEES E
WHERE E.DEPARTMENT_ID in (SELECT DEPARTMENT_ID FROM DEPARTMENTS WHERE DEPARTMENT_NAME = 'Executive')

 7. 평균 급여보다 많은 급여를 받고 이름에 u가 포함된 사원과 같은 부서에서 근무하는 모든 사원의 번호, 이름 및 급여를 표시하십시오.

SELECT E.DEPARTMENT_ID, E.LAST_NAME, E.JOB_ID
FROM EMPLOYEES E
WHERE E.SALARY > (SELECT AVG(SALARY) FROM EMPLOYEES)
AND E.DEPARTMENT_ID in (SELECT DEPARTMENT_ID FROM EMPLOYEES WHERE LAST_NAME like '%u%')

 8. 미국(locations.country_id = ‘US’) 내에서 근무하는 사원들의 평균 급여보다 많은 급여를 받는 사원의 번호, 이름 및 급여를 표시하십시오.

SELECT EMPLOYEE_ID, LAST_NAME, SALARY
FROM EMPLOYEES
WHERE SALARY > (SELECT AVG(E.SALARY) 
    			FROM EMPLOYEES E, DEPARTMENTS D, LOCATIONS L  
    			WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID
    			AND D.LOCATION_ID = L.LOCATION_ID
    			AND L.COUNTRY_ID = 'US')

 9. 부서 별로 최고 급여를 받는 사원의 번호, 이름, 급여 몇 부서 번호를 표시하고 부서 번호에 대해 오름 차순 정렬을 하시오.

SELECT E.EMPLOYEE_ID, E.LAST_NAME, E.SALARY, E.DEPARTMENT_ID
FROM EMPLOYEES E
WHERE E.SALARY = (SELECT MAX(b.SALARY) FROM EMPLOYEES a, EMPLOYEES b
    			WHERE a.DEPARTMENT_ID = b.DEPARTMENT_ID
    			AND a.DEPARTMENT_ID = E.DEPARTMENT_ID)
ORDER BY DEPARTMENT_ID

 10. FROM 절을 사용하여 9 번 질의를 재 작성하시오.

SELECT E.EMPLOYEE_ID, E.LAST_NAME, E.SALARY, E.DEPARTMENT_ID
FROM EMPLOYEES E, (SELECT DEPARTMENT_ID, MAX(salary) "MAX" 
    				  FROM employees 
    				  GROUP BY DEPARTMENT_ID) M
WHERE E.DEPARTMENT_ID = M.DEPARTMENT_ID AND SALARY = MAX
ORDER BY DEPARTMENT_ID

 11. 사원이 한 명 이상 존재하는 부서의 번호 및 부서 이름을 표시하시오.(exists 키워드 사용)

SELECT D.DEPARTMENT_ID, D.DEPARTMENT_NAME
FROM DEPARTMENTS D
WHERE EXISTS (SELECT DEPARTMENT_ID FROM EMPLOYEES
    		  WHERE DEPARTMENT_ID = D.DEPARTMENT_ID)
ORDER BY DEPARTMENT_ID

 12. 다음을 참고하여 급여를 가장 적게 받는 사원 5명에 대한 정보를 표시하시오.

  select rownum, employee_id, last_name, salary
  from employees
  where rownum <= 5

SELECT rownum, E.EMPLOYEE_ID, E.LAST_NAME, E.SALARY
FROM (SELECT * FROM EMPLOYEES ORDER BY SALARY) E
WHERE rownum <= 5
